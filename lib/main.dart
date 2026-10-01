import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const StudyApp());

class C {
  static const lavender = Color(0xFFB69AF5), soft = Color(0xFFEDE7FF), blue = Color(0xFFAED8F5),
      mint = Color(0xFFBEE8D1), yellow = Color(0xFFFFD77A), pink = Color(0xFFF6B8D8),
      ink = Color(0xFF17171C), bg = Color(0xFFF9F8FC);
}

class Note { String title, body; Note(this.title, this.body); }
class CardItem { String q, a; CardItem(this.q, this.a); }
class Task { String title, time; bool done; Task(this.title, this.time, {this.done = false}); }

class StudyApp extends StatefulWidget {
  const StudyApp({super.key});
  @override State<StudyApp> createState() => _StudyAppState();
}
class _StudyAppState extends State<StudyApp> {
  ThemeMode theme = ThemeMode.light;
  @override Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner:false, title:'Study', themeMode:theme,
    theme:ThemeData(useMaterial3:true,scaffoldBackgroundColor:C.bg,colorScheme:ColorScheme.fromSeed(seedColor:C.lavender)),
    darkTheme:ThemeData(useMaterial3:true,brightness:Brightness.dark,colorScheme:ColorScheme.fromSeed(seedColor:C.lavender,brightness:Brightness.dark)),
    home:HomeShell(onTheme:()=>setState(()=>theme=theme==ThemeMode.light?ThemeMode.dark:ThemeMode.light)),
  );
}

class HomeShell extends StatefulWidget {
  final VoidCallback onTheme;
  const HomeShell({super.key,required this.onTheme});
  @override State<HomeShell> createState()=>_HomeShellState();
}
class _HomeShellState extends State<HomeShell> {
  int tab=0,sessions=0;
  final notes=<Note>[Note('Ottoman History','Review the rise of the Ottomans and major rulers.')];
  final cards=<CardItem>[CardItem('What language is the Quran in?','Arabic.'),CardItem('What is Zakat?','An obligatory form of charity for eligible Muslims.')];
  final tasks=<Task>[Task('Islamic History','8:00 – 9:00 AM'),Task('Arabic Language','10:00 – 11:00 AM'),Task('Revision','4:00 – 5:00 PM')];

  void timerPage()=>setState(()=>tab=2);
  @override Widget build(BuildContext context){
    final pages=[
      Dashboard(onTimer:timerPage,onNotes:notesPage,onCards:cardsPage,onQuiz:quizPage,onPlan:planPage),
      Subjects(onSearch:search),
      FocusTimer(onComplete:()=>setState(()=>sessions++)),
      Progress(completed:tasks.where((x)=>x.done).length,sessions:sessions),
      Profile(onTheme:widget.onTheme,onNotes:notesPage,onPlan:planPage,onCards:cardsPage,onHelp:help,onSettings:settings),
    ];
    return Scaffold(
      body:SafeArea(child:pages[tab]),
      bottomNavigationBar:NavigationBar(selectedIndex:tab,onDestinationSelected:(i)=>setState(()=>tab=i),destinations:const[
        NavigationDestination(icon:Icon(Icons.home_outlined),selectedIcon:Icon(Icons.home),label:'Home'),
        NavigationDestination(icon:Icon(Icons.menu_book_outlined),selectedIcon:Icon(Icons.menu_book),label:'Subjects'),
        NavigationDestination(icon:Icon(Icons.timer_outlined),selectedIcon:Icon(Icons.timer),label:'Timer'),
        NavigationDestination(icon:Icon(Icons.bar_chart_outlined),selectedIcon:Icon(Icons.bar_chart),label:'Progress'),
        NavigationDestination(icon:Icon(Icons.person_outline),selectedIcon:Icon(Icons.person),label:'Profile'),
      ]),
    );
  }
  void notesPage()=>showModalBottomSheet(context:context,isScrollControlled:true,showDragHandle:true,builder:(_)=>NotesView(notes:notes,refresh:()=>setState((){})));
  void cardsPage()=>showModalBottomSheet(context:context,isScrollControlled:true,showDragHandle:true,builder:(_)=>CardsView(cards:cards,refresh:()=>setState((){})));
  void quizPage()=>showModalBottomSheet(context:context,isScrollControlled:true,showDragHandle:true,builder:(_)=>const QuizView());
  void planPage()=>showModalBottomSheet(context:context,isScrollControlled:true,showDragHandle:true,builder:(_)=>PlanView(tasks:tasks,refresh:()=>setState((){}),start:(){Navigator.pop(context);timerPage();}));
  void search(){
    final c=TextEditingController();
    showDialog(context:context,builder:(_)=>AlertDialog(title:const Text('Search subjects'),content:TextField(controller:c,autofocus:true,decoration:const InputDecoration(hintText:'Arabic, Quran, History...')),actions:[
      TextButton(onPressed:()=>Navigator.pop(context),child:const Text('Cancel')),
      FilledButton(onPressed:(){Navigator.pop(context);final q=c.text.trim();showModalBottomSheet(context:context,showDragHandle:true,builder:(_)=>SearchResults(q:q));},child:const Text('Search'))
    ]));
  }
  void settings()=>showModalBottomSheet(context:context,showDragHandle:true,builder:(_)=>SettingsView(onTheme:(){Navigator.pop(context);widget.onTheme();}));
  void help()=>showDialog(context:context,builder:(_)=>AlertDialog(title:const Text('Help & Support'),content:const Text('Home has quick actions. Subjects lets you browse topics. Timer tracks focus sessions. Progress shows goals and statistics.'),actions:[TextButton(onPressed:()=>Navigator.pop(context),child:const Text('OK'))]));
}

class Dashboard extends StatelessWidget {
  final VoidCallback onTimer,onNotes,onCards,onQuiz,onPlan;
  const Dashboard({super.key,required this.onTimer,required this.onNotes,required this.onCards,required this.onQuiz,required this.onPlan});
  @override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(20),children:[
    Row(children:[Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text('Hello, Student',style:Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight:FontWeight.w900)),
      Text('Let’s make today productive.',style:TextStyle(color:Theme.of(context).colorScheme.onSurfaceVariant)),
    ])),const CircleAvatar(backgroundColor:C.soft,child:Icon(Icons.school,color:C.ink))]),
    const SizedBox(height:20),
    InkWell(borderRadius:BorderRadius.circular(28),onTap:onTimer,child:Container(padding:const EdgeInsets.all(22),decoration:BoxDecoration(gradient:const LinearGradient(colors:[Color(0xFFC8B4FF),Color(0xFFE3D9FF)]),borderRadius:BorderRadius.circular(28)),child:Row(children:[
      Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        const Text('Small\nSteps, Big Results',style:TextStyle(fontSize:27,fontWeight:FontWeight.w900,height:.98)),
        const SizedBox(height:10),const Text('Focus for a little while today and build a better tomorrow.'),
        const SizedBox(height:15),FilledButton(onPressed:onTimer,style:FilledButton.styleFrom(backgroundColor:C.ink,foregroundColor:Colors.white),child:const Text('Start focus')),
      ])),const Icon(Icons.auto_stories_rounded,size:82,color:Color(0xFF7B61D6)),
    ]))),
    const SizedBox(height:18),
    Row(children:[ActionBox('Notes',Icons.sticky_note_2_outlined,C.yellow,onNotes),ActionBox('Flashcards',Icons.style_outlined,C.soft,onCards),ActionBox('Q&A',Icons.quiz_outlined,C.mint,onQuiz),ActionBox('Plan',Icons.calendar_month_outlined,C.blue,onPlan)]),
    const SizedBox(height:24),
    Row(children:[const Expanded(child:Text("Today's Plan",style:TextStyle(fontSize:19,fontWeight:FontWeight.w900))),TextButton(onPressed:onPlan,child:const Text('See all'))]),
    ...[('Islamic History','8:00 – 9:00 AM',Icons.account_balance,C.soft),('Arabic Language','10:00 – 11:00 AM',Icons.translate,C.mint),('Revision','4:00 – 5:00 PM',Icons.auto_stories,C.pink)].map((x)=>ListTile(
      onTap:onTimer,leading:CircleAvatar(backgroundColor:x.$4,child:Icon(x.$3,color:C.ink)),title:Text(x.$1,style:const TextStyle(fontWeight:FontWeight.w700)),subtitle:Text(x.$2),trailing:const Icon(Icons.play_circle_fill_rounded))),
    const SizedBox(height:12),
    Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:C.yellow.withOpacity(.4),borderRadius:BorderRadius.circular(22)),child:const Row(children:[Icon(Icons.local_fire_department,size:32),SizedBox(width:12),Expanded(child:Text('7 day streak\nKeep your momentum going today.',style:TextStyle(fontWeight:FontWeight.w700)))])),
  ]);
}
class ActionBox extends StatelessWidget{
  final String title;final IconData icon;final Color color;final VoidCallback onTap;
  const ActionBox(this.title,this.icon,this.color,this.onTap,{super.key});
  @override Widget build(BuildContext context)=>Expanded(child:InkWell(onTap:onTap,borderRadius:BorderRadius.circular(18),child:Column(children:[
    Container(margin:const EdgeInsets.symmetric(horizontal:4),height:58,decoration:BoxDecoration(color:color,borderRadius:BorderRadius.circular(18)),child:Icon(icon,color:C.ink)),
    const SizedBox(height:6),Text(title,style:const TextStyle(fontSize:10,fontWeight:FontWeight.w700))
  ])));
}

class Subjects extends StatelessWidget{
  final VoidCallback onSearch;const Subjects({super.key,required this.onSearch});
  @override Widget build(BuildContext context){
    final data=[('Quran Studies',.60,C.mint,Icons.menu_book),('Arabic',.35,C.soft,Icons.translate),('Islamic History',.80,C.yellow,Icons.account_balance),('English',.40,C.blue,Icons.text_fields),('Logic & Thinking',.25,C.pink,Icons.psychology),('General Knowledge',.50,C.mint,Icons.public)];
    return ListView(padding:const EdgeInsets.all(20),children:[
      Header('Subjects',Icons.search,onSearch),const SizedBox(height:18),
      Wrap(spacing:12,runSpacing:12,children:data.map((x)=>SizedBox(width:((MediaQuery.sizeOf(context).width-52)/2).clamp(145.0,230.0),child:InkWell(
        borderRadius:BorderRadius.circular(23),
        onTap:()=>showDialog(context:context,builder:(_)=>AlertDialog(title:Text(x.$1),content:Text('Progress: '+(x.$2*100).round().toString()+'%. Use the Timer to study this subject.'),actions:[TextButton(onPressed:()=>Navigator.pop(context),child:const Text('Close'))])),
        child:Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:x.$3,borderRadius:BorderRadius.circular(23)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          CircleAvatar(backgroundColor:Colors.white70,child:Icon(x.$4,color:C.ink)),const SizedBox(height:18),Text(x.$1,style:const TextStyle(fontWeight:FontWeight.w800)),const SizedBox(height:5),const Text('Lessons',style:TextStyle(fontSize:11)),const SizedBox(height:12),LinearProgressIndicator(value:x.$2,minHeight:5,backgroundColor:Colors.white54),const SizedBox(height:6),Text((x.$2*100).round().toString()+'% complete',style:const TextStyle(fontSize:10,fontWeight:FontWeight.w700))
        ]))))).toList())
    ]);
  }
}

class FocusTimer extends StatefulWidget{
  final VoidCallback onComplete;const FocusTimer({super.key,required this.onComplete});
  @override State<FocusTimer> createState()=>_FocusTimerState();
}
class _FocusTimerState extends State<FocusTimer>{
  Timer? t;int mode=0,seconds=1500;bool running=false;
  final modes=[('Pomodoro',1500),('Short Break',300),('Long Break',900)];
  void choose(int i){t?.cancel();setState((){mode=i;seconds=modes[i].$2;running=false;});}
  void play(){
    if(running){t?.cancel();setState(()=>running=false);return;}
    setState(()=>running=true);
    t=Timer.periodic(const Duration(seconds:1),(_){
      if(seconds<=1){t?.cancel();setState((){seconds=0;running=false;});if(mode==0)widget.onComplete();showDialog(context:context,builder:(_)=>AlertDialog(title:const Text('Session complete'),content:const Text('Great work. Your progress was updated.'),actions:[TextButton(onPressed:()=>Navigator.pop(context),child:const Text('Continue'))]));}
      else setState(()=>seconds--);
    });
  }
  void reset(){t?.cancel();setState((){seconds=modes[mode].$2;running=false;});}
  @override void dispose(){t?.cancel();super.dispose();}
  @override Widget build(BuildContext context){
    final m=(seconds~/60).toString().padLeft(2,'0'),s=(seconds%60).toString().padLeft(2,'0');
    return ListView(padding:const EdgeInsets.all(20),children:[
      Header('Focus Timer',Icons.refresh,reset),const SizedBox(height:18),
      Row(children:modes.asMap().entries.map((e)=>Expanded(child:Padding(padding:const EdgeInsets.only(right:6),child:Pill(e.value.$1,e.key==mode,()=>choose(e.key))))).toList()),
      const SizedBox(height:35),
      Center(child:SizedBox(width:260,height:260,child:Stack(alignment:Alignment.center,children:[
        SizedBox(width:250,height:250,child:CircularProgressIndicator(value:seconds/modes[mode].$2,strokeWidth:13,backgroundColor:C.soft,color:C.lavender)),
        Column(mainAxisAlignment:MainAxisAlignment.center,children:[Text(m+':'+s,style:const TextStyle(fontSize:52,fontWeight:FontWeight.w900)),Text(modes[mode].$1)])
      ]))),
      const SizedBox(height:28),
      Row(mainAxisAlignment:MainAxisAlignment.center,children:[IconButton.filledTonal(onPressed:reset,icon:const Icon(Icons.refresh)),const SizedBox(width:24),FloatingActionButton.large(onPressed:play,backgroundColor:C.ink,foregroundColor:Colors.white,child:Icon(running?Icons.pause:Icons.play_arrow,size:34)),const SizedBox(width:24),IconButton.filledTonal(onPressed:reset,icon:const Icon(Icons.skip_next))])
    ]);
  }
}

class Progress extends StatefulWidget{
  final int completed,sessions;const Progress({super.key,required this.completed,required this.sessions});
  @override State<Progress> createState()=>_ProgressState();
}
class _ProgressState extends State<Progress>{
  int tab=0;
  @override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(20),children:[
    Header('My Progress',Icons.calendar_today,()=>showDatePicker(context:context,firstDate:DateTime(2020),lastDate:DateTime(2100),initialDate:DateTime.now())),
    const SizedBox(height:18),
    Row(children:['Overview','Subjects','Stats','Goals'].asMap().entries.map((e)=>Expanded(child:Padding(padding:const EdgeInsets.only(right:5),child:Pill(e.value,e.key==tab,()=>setState(()=>tab=e.key))))).toList()),
    const SizedBox(height:18),
    if(tab==0)...[StatGrid([(widget.sessions.toString(),'Focus sessions',C.soft),(widget.completed.toString(),'Tasks complete',C.mint),('32h','Study time',C.yellow),('85%','Weekly goal',C.blue)]),const SizedBox(height:12),const Chart()],
    if(tab==1)...['Quran Studies','Arabic','Islamic History','English'].map((x)=>ListTile(title:Text(x),subtitle:const Text('Progress this week'),trailing:const SizedBox(width:90,child:LinearProgressIndicator(value:.65)))),
    if(tab==2)StatGrid([('4.6h','Average daily',C.soft),('18','Lessons this week',C.mint),('92%','Quiz accuracy',C.yellow)]),
    if(tab==3)...[Goal('Study 10 hours this week',.72),Goal('Finish 12 lessons',(widget.completed/12).clamp(0.0,1.0)),const Goal('Keep a 7 day streak',.85)]
  ]);
}
class Goal extends StatelessWidget{final String title;final double value;const Goal(this.title,this.value,{super.key});@override Widget build(BuildContext c)=>ListTile(title:Text(title),subtitle:LinearProgressIndicator(value:value));}
class Chart extends StatelessWidget{const Chart({super.key});@override Widget build(BuildContext c)=>Container(height:180,padding:const EdgeInsets.all(20),decoration:BoxDecoration(color:C.soft,borderRadius:BorderRadius.circular(25)),child:Row(crossAxisAlignment:CrossAxisAlignment.end,mainAxisAlignment:MainAxisAlignment.spaceAround,children:[45.0,80,60,120,55,92,110].asMap().entries.map((e)=>Column(mainAxisAlignment:MainAxisAlignment.end,children:[Container(width:22,height:e.value,decoration:BoxDecoration(color:e.key==3?C.lavender:Colors.white70,borderRadius:BorderRadius.circular(10))),const SizedBox(height:6),Text(['M','T','W','T','F','S','S'][e.key],style:const TextStyle(fontSize:10))])).toList()));}
class StatGrid extends StatelessWidget{final List<(String,String,Color)> data;const StatGrid(this.data,{super.key});@override Widget build(BuildContext c)=>Wrap(spacing:8,runSpacing:8,children:data.map((x)=>SizedBox(width:(MediaQuery.sizeOf(c).width-48)/2,child:Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:x.$3,borderRadius:BorderRadius.circular(20)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(x.$1,style:const TextStyle(fontSize:23,fontWeight:FontWeight.w900)),Text(x.$2,style:const TextStyle(fontSize:10))])))).toList());}

class Profile extends StatelessWidget{
  final VoidCallback onTheme,onNotes,onPlan,onCards,onHelp,onSettings;
  const Profile({super.key,required this.onTheme,required this.onNotes,required this.onPlan,required this.onCards,required this.onHelp,required this.onSettings});
  @override Widget build(BuildContext c)=>ListView(padding:const EdgeInsets.all(20),children:[
    Header('Profile',Icons.settings,onSettings),const SizedBox(height:18),
    Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:Theme.of(c).colorScheme.surface,borderRadius:BorderRadius.circular(24)),child:const Row(children:[CircleAvatar(radius:30,backgroundColor:C.soft,child:Icon(Icons.school,size:28)),SizedBox(width:14),Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Student',style:TextStyle(fontSize:18,fontWeight:FontWeight.w800)),Text('Keep learning')])])),
    const SizedBox(height:15),StatGrid([('12','Subjects',C.soft),('85','Day streak',C.yellow),('240','Hours',C.mint)]),const SizedBox(height:10),
    Item('My Notes',Icons.note_alt_outlined,onNotes),Item('Flashcards',Icons.style_outlined,onCards),Item('Study Plan',Icons.calendar_month_outlined,onPlan),Item('Settings',Icons.settings_outlined,onSettings),Item('Help & Support',Icons.help_outline,onHelp),
    const SizedBox(height:10),OutlinedButton.icon(onPressed:onTheme,icon:const Icon(Icons.dark_mode),label:const Text('Toggle light / dark mode'))
  ]);
}
class Item extends StatelessWidget{final String title;final IconData icon;final VoidCallback onTap;const Item(this.title,this.icon,this.onTap,{super.key});@override Widget build(BuildContext c)=>ListTile(onTap:onTap,contentPadding:EdgeInsets.zero,leading:Icon(icon),title:Text(title,style:const TextStyle(fontWeight:FontWeight.w600)),trailing:const Icon(Icons.chevron_right));}

class NotesView extends StatefulWidget{
  final List<Note> notes;final VoidCallback refresh;const NotesView({super.key,required this.notes,required this.refresh});
  @override State<NotesView> createState()=>_NotesViewState();
}
class _NotesViewState extends State<NotesView>{
  String q='';
  @override Widget build(BuildContext c){final list=widget.notes.where((n)=>(n.title+' '+n.body).toLowerCase().contains(q.toLowerCase())).toList();return SafeArea(child:Padding(padding:const EdgeInsets.all(20),child:Column(mainAxisSize:MainAxisSize.min,children:[
    Row(children:[Expanded(child:Text('My Notes',style:Theme.of(c).textTheme.headlineSmall?.copyWith(fontWeight:FontWeight.w800))),IconButton(onPressed:add,icon:const Icon(Icons.add_circle))]),
    TextField(onChanged:(v)=>setState(()=>q=v),decoration:const InputDecoration(prefixIcon:Icon(Icons.search),hintText:'Search notes')),
    const SizedBox(height:8),
    Flexible(child:ListView(shrinkWrap:true,children:list.map((n)=>ListTile(title:Text(n.title,style:const TextStyle(fontWeight:FontWeight.w700)),subtitle:Text(n.body,maxLines:2,overflow:TextOverflow.ellipsis),onTap:()=>edit(n),trailing:IconButton(onPressed:(){widget.notes.remove(n);widget.refresh();setState((){});},icon:const Icon(Icons.delete_outline)))).toList()))
  ]))); }
  void add()=>edit(null);
  void edit(Note? n){final a=TextEditingController(text:n?.title??''),b=TextEditingController(text:n?.body??'');showDialog(context:context,builder:(_)=>AlertDialog(title:Text(n==null?'New note':'Edit note'),content:Column(mainAxisSize:MainAxisSize.min,children:[TextField(controller:a,decoration:const InputDecoration(labelText:'Title')),TextField(controller:b,maxLines:4,decoration:const InputDecoration(labelText:'Note'))]),actions:[
    TextButton(onPressed:()=>Navigator.pop(context),child:const Text('Cancel')),
    FilledButton(onPressed:(){if(a.text.trim().isEmpty)return;if(n==null)widget.notes.insert(0,Note(a.text.trim(),b.text.trim()));else{n.title=a.text.trim();n.body=b.text.trim();}widget.refresh();Navigator.pop(context);setState((){});},child:const Text('Save'))
  ]));}
}

class CardsView extends StatefulWidget{
  final List<CardItem> cards;final VoidCallback refresh;const CardsView({super.key,required this.cards,required this.refresh});
  @override State<CardsView> createState()=>_CardsViewState();
}
class _CardsViewState extends State<CardsView>{
  int i=0;bool flip=false;
  @override Widget build(BuildContext c){if(widget.cards.isEmpty)return const Padding(padding:EdgeInsets.all(30),child:Text('No flashcards.'));final x=widget.cards[i];return SafeArea(child:Padding(padding:const EdgeInsets.all(20),child:Column(mainAxisSize:MainAxisSize.min,children:[
    Row(children:[Expanded(child:Text('Flashcards',style:Theme.of(c).textTheme.headlineSmall?.copyWith(fontWeight:FontWeight.w800))),IconButton(onPressed:add,icon:const Icon(Icons.add_circle))]),
    InkWell(onTap:()=>setState(()=>flip=!flip),child:Container(height:230,width:double.infinity,padding:const EdgeInsets.all(25),decoration:BoxDecoration(color:C.soft,borderRadius:BorderRadius.circular(28)),child:Center(child:Text(flip?x.a:x.q,textAlign:TextAlign.center,style:const TextStyle(fontSize:22,fontWeight:FontWeight.w800))))),
    const SizedBox(height:10),Row(mainAxisAlignment:MainAxisAlignment.center,children:[IconButton(onPressed:()=>setState((){i=(i-1+widget.cards.length)%widget.cards.length;flip=false;}),icon:const Icon(Icons.arrow_back)),Text((i+1).toString()+' / '+widget.cards.length.toString()),IconButton(onPressed:()=>setState((){i=(i+1)%widget.cards.length;flip=false;}),icon:const Icon(Icons.arrow_forward))])
  ]))); }
  void add(){final q=TextEditingController(),a=TextEditingController();showDialog(context:context,builder:(_)=>AlertDialog(title:const Text('New flashcard'),content:Column(mainAxisSize:MainAxisSize.min,children:[TextField(controller:q,decoration:const InputDecoration(labelText:'Question')),TextField(controller:a,decoration:const InputDecoration(labelText:'Answer'))]),actions:[
    TextButton(onPressed:()=>Navigator.pop(context),child:const Text('Cancel')),
    FilledButton(onPressed:(){if(q.text.trim().isEmpty||a.text.trim().isEmpty)return;widget.cards.add(CardItem(q.text.trim(),a.text.trim()));widget.refresh();Navigator.pop(context);setState((){});},child:const Text('Add'))
  ]));}
}

class QuizView extends StatefulWidget{const QuizView({super.key});@override State<QuizView> createState()=>_QuizViewState();}
class _QuizViewState extends State<QuizView>{
  final qs=[('Which language is primarily used for the Quran?',['Arabic','Urdu','Turkish','Persian'],0),('Which city became the Ottoman capital in 1453?',['Cairo','Constantinople','Baghdad','Damascus'],1),('What does Zakat describe?',['A fast','A prayer','Obligatory charity','A pilgrimage'],2)];
  int i=0,score=0;
  @override Widget build(BuildContext c){final x=qs[i];return SafeArea(child:Padding(padding:const EdgeInsets.all(20),child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.start,children:[
    Text('Quick Q&A',style:Theme.of(c).textTheme.headlineSmall?.copyWith(fontWeight:FontWeight.w800)),Text('Question '+(i+1).toString()+' of '+qs.length.toString()),const SizedBox(height:15),Text(x.$1,style:const TextStyle(fontSize:19,fontWeight:FontWeight.w800)),const SizedBox(height:12),
    ...List.generate(x.$2.length,(j)=>Padding(padding:const EdgeInsets.only(bottom:8),child:OutlinedButton(onPressed:()=>answer(j),child:Align(alignment:Alignment.centerLeft,child:Text(x.$2[j])))))
  ]))); }
  void answer(int a){if(a==qs[i].$3)score++;if(i==qs.length-1){showDialog(context:context,builder:(_)=>AlertDialog(title:const Text('Quiz complete'),content:Text('You scored '+score.toString()+' / '+qs.length.toString()),actions:[TextButton(onPressed:(){Navigator.pop(context);Navigator.pop(context);},child:const Text('Done'))]));}else setState(()=>i++);}
}

class PlanView extends StatefulWidget{
  final List<Task> tasks;final VoidCallback refresh,start;const PlanView({super.key,required this.tasks,required this.refresh,required this.start});
  @override State<PlanView> createState()=>_PlanViewState();
}
class _PlanViewState extends State<PlanView>{
  @override Widget build(BuildContext c)=>SafeArea(child:Padding(padding:const EdgeInsets.all(20),child:Column(mainAxisSize:MainAxisSize.min,children:[
    Row(children:[Expanded(child:Text('Study Plan',style:Theme.of(c).textTheme.headlineSmall?.copyWith(fontWeight:FontWeight.w800))),IconButton(onPressed:add,icon:const Icon(Icons.add_circle))]),
    ...widget.tasks.map((x)=>CheckboxListTile(value:x.done,onChanged:(v){x.done=v??false;widget.refresh();setState((){});},title:Text(x.title,style:TextStyle(decoration:x.done?TextDecoration.lineThrough:null,fontWeight:FontWeight.w700)),subtitle:Text(x.time))),
    FilledButton.icon(onPressed:widget.start,icon:const Icon(Icons.play_arrow),label:const Text('Start focus'))
  ])));
  void add(){final a=TextEditingController(),b=TextEditingController();showDialog(context:context,builder:(_)=>AlertDialog(title:const Text('Add study task'),content:Column(mainAxisSize:MainAxisSize.min,children:[TextField(controller:a,decoration:const InputDecoration(labelText:'Task')),TextField(controller:b,decoration:const InputDecoration(labelText:'Time'))]),actions:[
    TextButton(onPressed:()=>Navigator.pop(context),child:const Text('Cancel')),
    FilledButton(onPressed:(){if(a.text.trim().isEmpty)return;widget.tasks.add(Task(a.text.trim(),b.text.trim().isEmpty?'Any time':b.text.trim()));widget.refresh();Navigator.pop(context);setState((){});},child:const Text('Add'))
  ]));}
}

class SearchResults extends StatelessWidget{
  final String q;const SearchResults({super.key,required this.q});
  @override Widget build(BuildContext c){final all=['Quran Studies','Arabic','Islamic History','English','Logic & Thinking','General Knowledge'];final r=q.isEmpty?all:all.where((x)=>x.toLowerCase().contains(q.toLowerCase())).toList();return SafeArea(child:Padding(padding:const EdgeInsets.all(20),child:Column(mainAxisSize:MainAxisSize.min,children:[Text('Search results',style:Theme.of(c).textTheme.headlineSmall?.copyWith(fontWeight:FontWeight.w800)),if(r.isEmpty)const Text('No subjects found.'),...r.map((x)=>ListTile(leading:const Icon(Icons.menu_book),title:Text(x),trailing:const Icon(Icons.chevron_right)))])));}}
class SettingsView extends StatelessWidget{
  final VoidCallback onTheme;const SettingsView({super.key,required this.onTheme});
  @override Widget build(BuildContext c)=>SafeArea(child:Padding(padding:const EdgeInsets.all(20),child:Column(mainAxisSize:MainAxisSize.min,children:[Text('Settings',style:Theme.of(c).textTheme.headlineSmall?.copyWith(fontWeight:FontWeight.w800)),ListTile(leading:const Icon(Icons.dark_mode),title:const Text('Light / dark theme'),onTap:onTheme),ListTile(leading:const Icon(Icons.info_outline),title:const Text('About Study'),onTap:()=>showAboutDialog(context:c,applicationName:'Study',applicationVersion:'1.0.0'))])));}

class Header extends StatelessWidget{
  final String title;final IconData icon;final VoidCallback onTap;const Header(this.title,this.icon,this.onTap,{super.key});
  @override Widget build(BuildContext c)=>Row(children:[Expanded(child:Text(title,style:const TextStyle(fontSize:28,fontWeight:FontWeight.w900))),IconButton.filledTonal(onPressed:onTap,icon:Icon(icon))]);
}
class Pill extends StatelessWidget{
  final String text;final bool selected;final VoidCallback onTap;const Pill(this.text,this.selected,this.onTap,{super.key});
  @override Widget build(BuildContext c)=>InkWell(onTap:onTap,borderRadius:BorderRadius.circular(18),child:Container(padding:const EdgeInsets.symmetric(vertical:11,horizontal:8),decoration:BoxDecoration(color:selected?C.ink:Theme.of(c).colorScheme.surface,borderRadius:BorderRadius.circular(18)),child:Center(child:Text(text,style:TextStyle(color:selected?Colors.white:null,fontSize:11,fontWeight:FontWeight.w700))));
}
