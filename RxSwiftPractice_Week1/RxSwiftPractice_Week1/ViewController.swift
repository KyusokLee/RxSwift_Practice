//
//  ViewController.swift
//  RxSwiftPractice_Week1
//
//  Created by Kyus'lee on 2023/02/22.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let intA = BehaviorSubject(value: 1)
    let intB = BehaviorSubject(value: 2)

    override func viewDidLoad() {
        super.viewDidLoad()
        // ObservableをSequenceとも呼ぶようだ
        // Observableは、Eventを伝達する
        // Observerは、Observableを監視しながら、伝達されるEventを処理する
        // Observableを監視していることを、Subscribeと呼ぶ
        // そのため、ObserverをSubscriberとも呼ぶ
        // Observableが伝達する3つのイベント: Next, Error, Completed
        // Observableで発生した新たなEventはNextイベントを通して伝達される
        // Eventに値が踏まれているのなら、Nextイベントとともに伝達される
        // 値がNextイベントとともに、伝達されるこを🔥Emission(放出)と呼ぶ
        // ObservableのLife Cycleの間、Nextイベントが一度も伝達されない場合もあり、一つ以上伝達される場合もある
        // Observableでは、Errorが発生したら、Errorイベントが伝達され、終了となる
        // Observableが正常に終了されたら、completedイベントが伝達される
        // Error, CompletedイベントはObservableのLife Cycleで最後に伝達される。
        //  - 以降、Observableが終了され、全てのResourceが整理されるので、他のイベントは伝達されない
        // Error, Completedは Emission(Next)と呼ばず、⚠️Notificationと呼ぶ
        
        // Observableを生成する2つの方法
        // 1. create演算子を用いて、Observableの動作を直接実装する方法
        // なぜ？演算子と呼ぶのか。。？ -> create演算子は、ObservableType Protocolで宣言されたType メソッドであり、RxSwiftではこのようなメソッドを Operator(演算子)と呼ぶらしい
        
        Observable<Int>.create { observer -> Disposable in
            observer.on(.next(0)) // observerへ0が保存されているnextイベントがs伝達される
            observer.onNext(1) // observerへ1が保存されているnextイベントが伝達される
            observer.on(.completed) // observerへcompletedイベントが伝達され、Observableが終了される.以降、他のイベントを伝えることはできない
            
            // Disposablesはメモリ整理に必要な個体(Entity). ClassではなくStructタイプ
            return Disposables.create()
        }
        
        // 2. 既に定義された規則に沿って、イベントを伝達する方法
        // from 演算子を使う
        Observable.from([0, 1]) // 0 -> 1 準にnextイベントに伝達
        
        // 📌ここまでのコードは、Observableを生成するまでのコードである。つまり、Observerに伝達されず、ObservableはObserverにどのような順序で値が伝達されるべきかを定義するだけ！
        // 🧐じゃ、その伝達される時点はいつなの？？？！それは、ObserverがObservableをsubscribeする瞬間だ！🥰
        // その時点で、上記で定義した0, 1がnextイベントを通して伝達され、以降Completedイベントが伝達されたらObservableは終了
        
        Observable.just("Hello, RxSwift!")
            .subscribe { print($0) }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(intA, intB) { $0 + $1 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        // 3, 14が出力される
        // 値の変化が検知され、a + bの値が持続的に出力される
        intA.onNext(12)
    }


}

