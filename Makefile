.ONESHELL:
run_mlflow:
	mlflow run .

.ONESHELL:
download_data:
	mlflow run . -P hydra_options="main.execute_steps='download,preprocess'"

.ONESHELL:
execute_only_model:
	mlflow run . -P hydra_options="main.execute_steps='random_forest'"

.ONESHELL:
run_multiple_experiments:
	mlflow run . -P hydra_options="-m \
	hydra/launcher=joblib \
	random_forest_pipeline.random_forest.n_estimators=300,400 \
	random_forest_pipeline.random_forest.max_depth=range(6,10,2)"

# https://hydra.cc/docs/plugins/ax_sweeper/
