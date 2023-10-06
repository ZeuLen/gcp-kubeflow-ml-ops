import xgboost as xgb
from xgboost import XGBClassifier
from google.cloud import storage

BUCKET_ID = <YOUR_BUCKET_NAME>

def training_via_xgboost(x_train, y_train):
    useTrainCV = True,
    cv_folds = 5,
    early_stopping_rounds = 50
    alg = XGBClassifier(learning_rate=0.1, n_estimators=140, max_depth=5,
                        min_child_weight=3, gamma=0.2, subsample=0.6, colsample_bytree=1.0,
                        objective='binary:logistic', nthread=4, scale_pos_weight=1, seed=27)
    xgb_param = alg.get_xgb_params()
    xgtrain = xgb.DMatrix(x_train.values, label=y_train.values)

    cvresult = xgb.cv(xgb_param, xgtrain, num_boost_round=alg.get_params()['n_estimators'], nfold=cv_folds,
                      early_stopping_rounds=early_stopping_rounds)
    alg.set_params(n_estimators=cvresult.shape[0])

    alg.fit(x_train, y_train, eval_metric='auc')
    model = '0001.model'
    alg.save_model(model)
    store_model_in_gcs(model)

def store_model_in_gcs(model):
    bucket = storage.Client().bucket(BUCKET_ID)
    blob = bucket.blob('{}/{}'.format(
        datetime.datetime.now().strftime('census_%Y%m%d_%H%M%S'),
        model))
    blob.upload_from_filename(model)


