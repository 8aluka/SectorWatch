# SectorWache
HDDのSMART値をチェック、異常があればSlackへ通知するスクリプト

代替処理済のセクタ数・代替処理保留中のセクタ数のSMART値を読み、0より値が大きければSlackへ通知する  
コードはシェルスクリプトで記述しており、Slackの通知部には [Incoming WebHooks](https://api.slack.com/messaging/webhooks) を使用している  
Linux環境であれば何もしなくても動くはず（**要root権限**、裏でsmartmontoolsを呼び出しているため）  


Slackの使用したいチームにIncoming WebHooksを追加し、生成されたURLをスクリプト内のマスクされた部分と置換すればOK  

上記のスクリプトをCrontabに登録して定期的に自動実行させておけば、異常が発生した時に初めてSlackへ通知が行く
