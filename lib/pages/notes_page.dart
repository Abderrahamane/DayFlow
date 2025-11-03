import 'package:flutter/material.dart';
import '/widgets/note_item.dart'; // <-- make sure this imports your NoteItem widget file
import 'note_page_write.dart';
import '/models/note_model.dart';

// Global variable : 
List <Note> notes = List.empty(growable : true) ; 

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {

  // create static list one Notes 


  // title and content taht we will get from the Note page 
  late Note returnedNote ;



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: notes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.note_outlined,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Notes Page',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Note-taking features coming soon!',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                Note singleNote = notes[index] ; 
                // set the onDelete Fucntion 
                singleNote.onDelete = (){
                  notes.remove(notes[index]) ;
                  setState(() {
                    
                  });
                }  ;

                // set the onTap function 
                singleNote.onTap = () async {
                  // will go to a nota page with the content of this note 
                  await Navigator.push
                  (
                    context ,
                    MaterialPageRoute(builder: (contex) => NotePageWrite(note : singleNote ) ) , 
                   ) ; 
                   //sort 
                    notes.sort((a, b) {
                      final aTime = a.updatedAt ?? a.createdAt!;
                      final bTime = b.updatedAt ?? b.createdAt!;
                      return bTime.compareTo(aTime); // newest note first
                  });
                   // should update the UI
                   
                   setState(() {
                     
                   });
                } ; 
                
                return NoteItem(note: singleNote);   
                               
              },
            ),

            // add the floting btm 
            floatingActionButton: FloatingActionButton(
              onPressed: () async{
                // we should wait to get the data then continue the code 
                returnedNote = await Navigator.push(
                  context , 
                  MaterialPageRoute(builder: (contex)=> const NotePageWrite()) ,
                  ) ; 
                // refresh teh UI if it is updated 
                if(returnedNote != null) {
                  // sort the
                    notes.sort((a, b) {
                      final aTime = a.updatedAt ?? a.createdAt!;
                      final bTime = b.updatedAt ?? b.createdAt!;
                      return bTime.compareTo(aTime); // newest note first
                  });
                   // should update the UI
                  
                  setState(() {
                    
                  });
                }
                 
                //Add the content to the map 
                inNewNoteCreated(returnedNote) ; // if it already exist , it will not add ( they can knew that )

                // add tegh methods to it 

                print(notes) ; 
              }, 
              child: const Icon(Icons.add),
              )


    );

    // Functions : 



  }


  // Functions : 


  // create the note
  void inNewNoteCreated(Note note) {
    notes.add(note) ;
    notes.sort((a, b) {
      final aTime = a.updatedAt ?? a.createdAt!;
      final bTime = b.updatedAt ?? b.createdAt!;
      return bTime.compareTo(aTime); // newest note first
});
    setState(() {
      
    });

  }

  // delete the note
  void onNoteDeleted(Note note) {
    notes.remove(note) ; 
    setState(() {
      
    });
  }

  //LATER : I should another one for Note Edit ( when click on it to open )

}
