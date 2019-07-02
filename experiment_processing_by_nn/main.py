""" Learning artificial neural network by TensorFLow.keras."""
import numpy as np
import matplotlib.pyplot as plt
import PyGnuplot as gp
import datetime as dt
from keras.models import load_model
from keras.models import Sequential
from keras.callbacks import EarlyStopping
from keras.utils import multi_gpu_model
from keras.layers import Dense
from keras import optimizers
# Just disables the warning, doesn't enable AVX/FMA
import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'


def data_split(x_dataset, y_dataset, ratio=0.8):
    """ Split input data to test data and train data by ratio.

    Return splited data.
    """
    x_dataset_size = len(x_dataset)

    y_dataset_size = len(y_dataset)

    x_dataset_train = x_dataset[:int(x_dataset_size * ratio)]

    y_dataset_train = y_dataset[:int(y_dataset_size * ratio)]

    x_dataset_test = x_dataset[int(x_dataset_size * ratio):]

    y_dataset_test = y_dataset[int(y_dataset_size * ratio):]

    return x_dataset_train, x_dataset_test, y_dataset_train, y_dataset_test


def prepare_data(filename='database_old.csv', delimiter=',', border=-6, to_delete=None):
    db = np.genfromtxt(filename, delimiter=delimiter)

    if to_delete is not None:
        for column in to_delete:
            np.delete(db, column)

    x_train, x_test, y_train, y_test = data_split(db[:, :border], db[:, border:])

    mean = x_train.mean(axis=0)

    std = x_train.std(axis=0)

    x_train -= mean

    x_train /= std

    x_test -= mean

    x_test /= std

    return x_train, x_test, y_train, y_test


def timer(func):
    import time

    def wrapper(*args, **kwargs):
        t = time.clock()

        res = func(*args, **kwargs)

        print(func.__name__, time.clock() - t)

        return res

    return wrapper


@timer
def main(*args):
    #to_delete = (6, 7, 8, 11, 14, 17)

    to_delete = (6, 7, 8, 9, 10, 11, 18, 19, 20)

    x_train, x_test, y_train, y_test = prepare_data(to_delete=to_delete)

    epochs = args[0]

    verbose = args[1]

    border = args[2]

    # border = x_test.shape[1]

    def set_model():
        # try:
        #    model = load_model('model.h5')

        # except OSError:
        input_shape = x_train.shape[1]

        hidden_input_shape = input_shape * 2

        model = Sequential()

        model.add(Dense(hidden_input_shape, activation='relu', input_shape=(input_shape,)))

        # model.add(Dense(hidden_input_shape, activation='relu', input_shape=(hidden_input_shape,)))

        # model.add(Dense(hidden_input_shape, activation='relu', input_shape=(hidden_input_shape,)))

        # model.add(Dense(hidden_input_shape, activation='relu', input_shape=(hidden_input_shape,)))

        # model.add(Dense(hidden_input_shape, activation='relu', input_shape=(hidden_input_shape,)))

        model.add(Dense(1, input_shape=(hidden_input_shape, )))

        # sgd = optimizers.SGD(lr=0.01, clipvalue=0.5)

        # model = multi_gpu_model(model, gpus=2)

        model.compile(optimizer='adam', loss='mse', metrics=['mae'])

        model.save('model.h5')

        return model

    model = set_model()

    names = ('F1', 'F2', 'F3', 'G1', 'G2', 'G3')

    t = np.linspace(0, 3.5, border)

    for i in range(0, len(names)):
        print(names[i])

        # early_stopping = EarlyStopping(monitor='val_loss', patience=2)

        model.fit(x_train, y_train[:, i], epochs=epochs, verbose=verbose, shuffle=True, batch_size=500,
                  validation_data=(x_test, y_test[:, i])) #, callbacks=[early_stopping])

        pred = model.predict(x_test[:border])

        pred_train = model.predict(x_train[:border])

        gp.c("set terminal eps enhanced size 10cm,10cm font 'Times-Roman,12'")

        gp.s([t, pred[:border].reshape(border, ), pred_train[:border].reshape(border, ), y_test[:border, i],
              y_train[:border, i]], filename='{0}_plot_data.dat'.format(names[i]))

        gp.c("set style line 12 dashtype 2 lc 'black'")

        gp.c("set grid xtics, ytics ls 12")

        gp.c("set output 'pics/{0} {1}.eps'".format(names[i],
                                                    dt.datetime.strftime(dt.datetime.now(), '%Y %h %d %H:%M')))

        gp.c("set xlabel 't'")

        gp.c("set ylabel '{0}'".format(names[i]))

        gp.c("plot '{0}_plot_data.dat' u 1:4 title '{0} (experiment)' w l lw 4 lc 'black',\
             '{0}_plot_data.dat' u 1:2 title '{0} (nn response)' w l dashtype 4 lw 2 lc 'red'".format(names[i]))

        gp.c("set output 'pics/{0} {1}-QD.eps'".format(names[i],
                                                       dt.datetime.strftime(dt.datetime.now(), '%Y %h %d %H:%M')))
        gp.c("set key top left")

        gp.c("set xlabel '{0} (experiment)'".format(names[i]))

        gp.c("set ylabel '{0} (nn response)'".format(names[i]))

        gp.c("plot '{0}_plot_data.dat' u 3:5 title 'Training set' w p pt 7 ps 1 lc 'black',\
             '{0}_plot_data.dat' u 2:4 title 'Testing set' w p pt 4 ps 1 lc 'red'".format(names[i]))

        print(names[i], '--- Done')

    plt.show()


epochs = 15000

verbose = 2

bord = 100

print(main(epochs, verbose, bord))
