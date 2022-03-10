import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_consume_api/network/network_enums.dart';
import 'package:flutter_consume_api/network/network_helper.dart';
import 'package:flutter_consume_api/network/network_service.dart';
import 'package:flutter_consume_api/network/query_param.dart';
import 'package:flutter_consume_api/static/static_values.dart';

import 'models/article_model.dart';
import 'widgets/article_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Consume Rest API',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  double width = 200, height = 200;
  @override
  Widget build(BuildContext context) {
    RendererBinding.instance?.setSemanticsEnabled(true);
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Articles'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
            // final json = snapshot.data;

            final List<Article> articles = snapshot.data as List<Article>;

            return ListView.builder(
              itemBuilder: (context, index){
                return Semantics(
                  label: 'Article widget Title ${articles[index].title}',
                    child: ArticleWidget(article: articles[index]));
              },
              itemCount: articles.length,
            );
          }else if(snapshot.hasError){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 25,
                  ),
                  SizedBox(height: 10,),
                  Text('Something Went Wrong')
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }

  Future<List<Article>?> getData() async {
    final response = await NetworkService.sendRequest(
        requestType: RequestType.get,
        url: StaticValues.apiUrl,
      queryParam: QP.apiQP(
          apiKey: StaticValues.apiKey, country: StaticValues.apiCountry)
    );

    debugPrint('Response ${response?.statusCode}');

    return await NetworkHelper.filterResponse(
        callBack: _listOfArticlesFromJson,
        response: response,
        parameterName: CallBackParameterName.articles,
        onFailureCallBackWithMessage: (errorType, msg){
          debugPrint('Error type-$errorType - Message $msg');
          return null;
        }
    );
  }

  List<Article> _listOfArticlesFromJson(json) => (json as List)
      .map((e) => Article.fromJson(e as Map<String, dynamic>))
      .toList();
}





