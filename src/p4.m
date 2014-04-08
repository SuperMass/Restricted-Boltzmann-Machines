%% problem 4: initialize 
%  not necessary to run it if train_feature.txt and test_feature.txt is
%  already under src/
clear all
close all
load r3_1
K = size(WP, 2);
D = size(WP, 1);

data_path = '../Data/';

train_data_x_name = 'MNISTXtrain.txt';
train_data_x = load([data_path, train_data_x_name]);
train_label_name = 'MNISTYtrain.txt';
train_label = load([data_path, train_label_name]);

test_data_x_name = 'MNISTXtest.txt';
test_data_x = load([data_path, test_data_x_name]);
test_label_name = 'MNISTYtest.txt';
test_label = load([data_path, test_label_name]);

N_train = size(train_data_x, 1);
pk0_train = 1.0 ./ (1+exp(ones(N_train, 1) * WB + (WP' * train_data_x')'));
hck_train = ones(N_train, K);
hck_train(rand(N_train, K) < pk0_train) = 0;
svmlight_write(train_label, hck_train, 'train_feature.txt')

N_test = size(test_data_x, 1);
pk0_test = 1.0 ./ (1+exp(ones(N_test, 1) * WB + (WP' * test_data_x')'));
hck_test = ones(N_test, K);
hck_test(rand(N_test, K) < pk0_test) = 0;
svmlight_write(test_label, hck_test, 'test_feature.txt')

svmlight_write(train_label, train_data_x, 'train_feature_raw.txt')
svmlight_write(test_label, test_data_x, 'test_feature_raw.txt')

%% 4(a) is run in the terminal with following commands
% ./svm_multiclass_learn -c 1000000 -v 2 -e 1 train_feature.txt model.txt
% ./svm_multiclass_classify -v 2 test_feature.txt model.txt prediction.txt

%% 4(b) is run in the terminal with following commands
% ./svm_multiclass_learn -c 1000000 -v 2 -e 1 train_feature_raw.txt model_raw.txt
% ./svm_multiclass_classify -v 2 test_feature_raw.txt model_raw.txt prediction_raw.txt