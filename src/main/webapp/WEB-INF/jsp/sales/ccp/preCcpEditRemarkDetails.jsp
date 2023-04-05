<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
 <style>
     #container {
         width: 100%;
     }
     .ck-editor__editable[role="textbox"] {
         min-height: 300px ;
     }
     .ck-content .image {
         max-width: 100%;
     }
 </style>

 <div class="popup_wrap size_big">
     <header class="pop_header">
         <h1>${remarkDetails.chsStus} - ${remarkDetails.chsRsn}</h1>
         <ul class="right_opt">
             <li><p class="btn_blue2"><a id="eclose">CLOSE</a></p></li>
         </ul>
     </header>
     <section class="pop_body">
        <input type="hidden" name="editorId"  id="editorId" value="${remarkDetails.remarkId}"/>
        <div id="editor" contenteditable="true"></div>
        <ul class="center_btns">
                <li><p class="btn_blue2 big"><a id="vsave">SAVE</a></p></li>
            </ul>
     </section>
 </div>


 <script>

       CKEDITOR.ClassicEditor.create(document.getElementById("editor"), {
                    toolbar: {
                        items: [
//                             'exportPDF','exportWord', '|',
                            'findAndReplace', 'selectAll', '|',
                            'heading', '|',
                            'bold', 'italic', 'strikethrough', 'underline',
//                             'code', 'subscript', 'superscript', 'removeFormat',
                            '|',
                            'bulletedList', 'numberedList', 'todoList', '|',
                            'outdent', 'indent', '|',
                            'undo', 'redo',
                            '-',
                            'fontSize', 'fontFamily', 'fontColor', 'fontBackgroundColor',
//                             'highlight', '|',
                            'alignment', '|',
//                             'link', 'insertImage', 'blockQuote', 'insertTable', 'mediaEmbed', 'codeBlock', 'htmlEmbed', '|',
//                             'specialCharacters', 'horizontalLine', 'pageBreak', '|',
//                             'textPartLanguage', '|',
//                             'sourceEditing'
                        ],
                        shouldNotGroupWhenFull: true
                    },

                    list: {
                        properties: {
                            styles: true,
                            startIndex: true,
                            reversed: true
                        }
                    },

                    heading: {
                        options: [
                            { model: 'paragraph', title: 'Paragraph', class: 'ck-heading_paragraph' },
                            { model: 'heading1', view: 'h1', title: 'Heading 1', class: 'ck-heading_heading1' },
                            { model: 'heading2', view: 'h2', title: 'Heading 2', class: 'ck-heading_heading2' },
                            { model: 'heading3', view: 'h3', title: 'Heading 3', class: 'ck-heading_heading3' },
                            { model: 'heading4', view: 'h4', title: 'Heading 4', class: 'ck-heading_heading4' },
                            { model: 'heading5', view: 'h5', title: 'Heading 5', class: 'ck-heading_heading5' },
                            { model: 'heading6', view: 'h6', title: 'Heading 6', class: 'ck-heading_heading6' }
                        ]
                    },

//                     placeholder: 'Welcome to CKEditor 5!',

                    fontFamily: {
                        options: [
                            'default',
                            'Arial, Helvetica, sans-serif',
                            'Courier New, Courier, monospace',
                            'Georgia, serif',
                            'Lucida Sans Unicode, Lucida Grande, sans-serif',
                            'Tahoma, Geneva, sans-serif',
                            'Times New Roman, Times, serif',
                            'Trebuchet MS, Helvetica, sans-serif',
                            'Verdana, Geneva, sans-serif'
                        ],
                        supportAllValues: true
                    },

                    fontSize: {
                        options: [ 10, 12, 14, 'default', 18, 20, 22 ],
                        supportAllValues: true
                    },

                    htmlSupport: {
                        allow: [
                            {
                                name: /.*/,
                                attributes: true,
                                classes: true,
                                styles: true
                            }
                        ]
                    },

                    htmlEmbed: {
                        showPreviews: true
                    },

                    link: {
                        decorators: {
                            addTargetToExternalLinks: true,
                            defaultProtocol: 'https://',
                            toggleDownloadable: {
                                mode: 'manual',
                                label: 'Downloadable',
                                attributes: {
                                    download: 'file'
                                }
                            }
                        }
                    },

                    mention: {
                        feeds: [
                            {
                                marker: '@',
                                feed: [
                                    '@apple', '@bears', '@brownie', '@cake', '@cake', '@candy', '@canes', '@chocolate', '@cookie', '@cotton', '@cream',
                                    '@cupcake', '@danish', '@donut', '@dragée', '@fruitcake', '@gingerbread', '@gummi', '@ice', '@jelly-o',
                                    '@liquorice', '@macaroon', '@marzipan', '@oat', '@pie', '@plum', '@pudding', '@sesame', '@snaps', '@soufflé',
                                    '@sugar', '@sweet', '@topping', '@wafer'
                                ],
                                minimumCharacters: 1
                            }
                        ]
                    },

                    removePlugins: [
                        'CKBox',
                        'CKFinder',
                        'EasyImage',
                        'RealTimeCollaborativeComments',
                        'RealTimeCollaborativeTrackChanges',
                        'RealTimeCollaborativeRevisionHistory',
                        'PresenceList',
                        'Comments',
                        'TrackChanges',
                        'TrackChangesData',
                        'RevisionHistory',
                        'Pagination',
                        'WProofreader',
                        'MathType'
                    ]
      }).then(editor => {

    	  editor.keystrokes.set( 'space', ( key, stop ) => {
              editor.execute( 'input', { text: '\u00a0' } );
              stop();
          });

    	  editor.setData(`${remarkDetails.appvReq}`);

    	  document.getElementById('vsave').onclick = (event) => {
    		  event.preventDefault()
    		  Common.showLoader()
    		  fetch("/sales/ccp/editRemarkRequest.do",{
    			  method : "POST",
    			  headers : {
    				  "Content-Type" : "application/json",
    			  },
    			  body : JSON.stringify({editorId : $("#editorId").val(), editorArea : editor.getData()})
    		  })
    		  .then( r=> r.json())
    		  .then(
    				  data => {
    					  Common.removeLoader()
    					  Common.alert(data.message,fn_reload)
    				  }
    		   )
    	  }
      });


</script>
