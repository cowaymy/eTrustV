<script type="text/javaScript" language="javascript">
  //var docGridID;
  var myFileCaches = {};
  var atchFileGrpId = 0;

  var sofFileId = 0;
  var nricFileId = 0;
  var otherFileId = 0;
  var otherFileId2 = 0;
  var otherFileId3 = 0;
  var otherFileId4 = 0;
  var otherFileId5 = 0;

  var sofFileName = "";
  var nricFileName = "";
  var otherFileName = "";
  var otherFileName2 = "";
  var otherFileName3 = "";
  var otherFileName4 = "";
  var otherFileName5 = "";


  $(document).ready(function() {
	  var atchFileGrpId = '${orderInfo.atchFileGrpId}';

	  if (atchFileGrpId != 0) {
	      fn_loadAtchment(atchFileGrpId);
	    }
    //createAUIGrid3();
  });

/*   function createAUIGrid3() {

    //AUIGrid 칼럼 설정
    var columnLayout = [ {
      headerText : '<spring:message code="sal.text.typeDoc" />',
      dataField : "codeName"
    }, {
      headerText : '<spring:message code="sal.text.submitDate" />',
      dataField : "docSubDt",
      width : 120
    }, {
      headerText : '<spring:message code="sal.text.quantity" />',
      dataField : "docCopyQty",
      width : 120
    } ];

    docGridID = GridCommon.createAUIGrid("grid_doc_wrap", columnLayout, "", gridPros);
  }

  function fn_selectDocumentList() {
    Common.ajax("GET", "/supplement/selectDocumentJsonList.do", {
      supRefId : '${orderInfo.supRefId}'
    }, function(result) {
      AUIGrid.setGridData(docGridID, result);
    });
  } */

  function fn_loadAtchment(atchFileGrpId) {
	    Common.ajax("Get", "/supplement/selectAttachList.do", {
	      atchFileGrpId : atchFileGrpId
	    }, function(result) {
	      //console.log(result);
	      if (result) {
	        if (result.length > 0) {
	          $("#attachTd").html("");
	          for (var i = 0; i < result.length; i++) {
	            switch (result[i].fileKeySeq) {
	            case '1':
	              sofFileId = result[i].atchFileId;
	              sofFileName = result[i].atchFileName;
	              $(".input_text[id='sofFileTxt']").val(sofFileName);
	              break;
	            case '2':
	              nricFileId = result[i].atchFileId;
	              nricFileName = result[i].atchFileName;
	              $(".input_text[id='nricFileTxt']")
	                  .val(nricFileName);
	              break;
	            case '3':
	              otherFileId = result[i].atchFileId;
	              otherFileName = result[i].atchFileName;
	              $(".input_text[id='otherFileTxt']").val(
	                  otherFileName);
	              break;
	            case '4':
	              otherFileId2 = result[i].atchFileId;
	              otherFileName2 = result[i].atchFileName;
	              $(".input_text[id='otherFileTxt2']").val(
	                  otherFileName2);
	              break;
	            case '5':
	              otherFileId3 = result[i].atchFileId;
	              otherFileName3 = result[i].atchFileName;
	              $(".input_text[id='otherFileTxt3']").val(
	                  otherFileName3);
	              break;
	            case '6':
	              otherFileId4 = result[i].atchFileId;
	              otherFileName4 = result[i].atchFileName;
	              $(".input_text[id='otherFileTxt4']").val(
	                  otherFileName4);
	              break;
	            case '7':
	              otherFileId5 = result[i].atchFileId;
	              otherFileName5 = result[i].atchFileName;
	              $(".input_text[id='otherFileTxt5']").val(
	                  otherFileName5);
	              break;
	            default:
	              Common.alert("no files");
	            }
	          }

	          $(".input_text").dblclick(function() {
	            var oriFileName = $(this).val();
	            var fileGrpId;
	            var fileId;
	            for (var i = 0; i < result.length; i++) {
	              if (result[i].atchFileName == oriFileName) {
	                fileGrpId = result[i].atchFileGrpId;
	                fileId = result[i].atchFileId;
	              }
	            }
	            if (fileId != null)
	              fn_atchViewDown(fileGrpId, fileId);
	          });
	        }
	      }
	    });
	  }

  function fn_atchViewDown(fileGrpId, fileId) {
	    var data = {
	      atchFileGrpId : fileGrpId,
	      atchFileId : fileId
	    };
	    Common.ajax("GET", "/eAccounting/webInvoice/getAttachmentInfo.do",
	        data, function(result) {
	          //console.log(result)
	          var fileSubPath = result.fileSubPath;
	          fileSubPath = fileSubPath.replace('\', ' / '');

	          if (result.fileExtsn == "jpg" || result.fileExtsn == "png"
	              || result.fileExtsn == "gif") {
	            //console.log(DEFAULT_RESOURCE_FILE + fileSubPath + '/' + result.physiclFileName);
	            window.open(DEFAULT_RESOURCE_FILE + fileSubPath + '/'
	                + result.physiclFileName);
	          } else {
	            //console.log("/file/fileDownWeb.do?subPath=" + fileSubPath + "&fileName=" + result.physiclFileName + "&orignlFileNm=" + result.atchFileName);
	            window.open("/file/fileDownWeb.do?subPath="
	                + fileSubPath + "&fileName="
	                + result.physiclFileName + "&orignlFileNm="
	                + result.atchFileName);
	          }
	        });
	  }

</script>

<article class="tap_area">
  <!-- <article class="grid_wrap">
    <div id="grid_doc_wrap" style="width: 100%; height: 380px; margin: 0 auto;"></div>
  </article> -->

  <section class="search_table">
            <!-- search_table start -->
            <aside class="title_line">
              <!-- title_line start -->
              <h3>
                <spring:message code="sal.text.attachment" />
              </h3>
            </aside>
            <!-- title_line end -->
            <table class="type1">
              <!-- table start -->
              <caption>table</caption>
              <colgroup>
                <col style="width: 30%" />
                <col style="width: *" />
              </colgroup>
              <tbody>
                <tr>
                  <th scope="row"><spring:message
                      code="supplement.text.eSofForm" /><span class="must">**</span></th>
                  <td>
                    <div class="auto_file2">
                      <input type="file" title="file add" id="sofFile"
                        accept="image/jpg, image/jpeg, image/png, application/pdf" />
                      <label> <input type='text' class='input_text'
                        readonly='readonly' id='sofFileTxt' /> <!-- <span class='label_text'><a href='#'>Upload</a></span> -->
                      </label>
                    </div>
                  </td>
                </tr>

                <tr>
                  <th scope="row"><spring:message
                      code="supplement.text.photocopyOfNric" /><span class="must">**</span></th>
                  <td>
                    <div class="auto_file2">
                      <input type="file" title="file add" id="nricFile"
                        accept="image/jpg, image/jpeg, image/png, application/pdf" />
                      <label> <input type='text' class='input_text'
                        readonly='readonly' id='nricFileTxt' /> <!-- <span class='label_text'>
                          <a href='#'>Upload</a></span> <span class='label_text'></span> -->
                      </label>
                    </div>
                  </td>
                </tr>

                <tr>
                  <th scope="row"><spring:message
                      code="supplement.text.other" />1</th>
                  <td>
                    <div class="auto_file2">
                      <input type="file" title="file add" id="otherFile"
                        accept="image/jpg, image/jpeg, image/png, application/pdf" />
                      <label> <input type='text' class='input_text'
                        readonly='readonly' id='otherFileTxt' /> <!-- <span class='label_text'>
                      <a href='#'>Upload</a></span>
                      <span class='label_text'>
                        <a href='#' onclick='fn_removeFile("OTH")'>Remove</a>
                      </span> -->
                      </label>
                    </div>
                  </td>
                </tr>

                <tr>
                  <th scope="row"><spring:message
                      code="supplement.text.other" />2</th>
                  <td>
                    <div class="auto_file2">
                      <input type="file" title="file add" id="otherFile2"
                        accept="image/jpg, image/jpeg, image/png, application/pdf" />
                      <label> <input type='text' class='input_text'
                        readonly='readonly' id='otherFileTxt2' /> <!-- <span class='label_text'>
                        <a href='#'>Upload</a>
                      </span>
                      <span class='label_text'>
                        <a href='#' onclick='fn_removeFile("OTH2")'>Remove</a>
                      </span> -->
                      </label>
                    </div>
                  </td>
                </tr>

                <tr>
                  <th scope="row"><spring:message
                      code="supplement.text.other" />3</th>
                  <td>
                    <div class="auto_file2">
                      <input type="file" title="file add" id="otherFile3"
                        accept="image/jpg, image/jpeg, image/png, application/pdf" />
                      <label> <input type='text' class='input_text'
                        readonly='readonly' id='otherFileTxt3' /> <!-- <span class='label_text'>
                        <a href='#'>Upload</a>
                      </span>
                      <span class='label_text'>
                        <a href='#' onclick='fn_removeFile("OTH3")'>Remove</a>
                      </span> -->
                      </label>
                    </div>
                  </td>
                </tr>

                <tr>
                  <th scope="row"><spring:message
                      code="supplement.text.other" />4</th>
                  <td>
                    <div class="auto_file2">
                      <input type="file" title="file add" id="otherFile4"
                        accept="image/jpg, image/jpeg, image/png, application/pdf" />
                      <label> <input type='text' class='input_text'
                        readonly='readonly' id='otherFileTxt4' /> <!-- <span class='label_text'>
                        <a href='#'>Upload</a>
                      </span>
                      <span class='label_text'>
                        <a href='#' onclick='fn_removeFile("OTH4")'>Remove</a>
                      </span> -->
                      </label>
                    </div>
                  </td>
                </tr>

                <tr>
                  <th scope="row"><spring:message
                      code="supplement.text.other" />5</th>
                  <td>
                    <div class="auto_file2">
                      <input type="file" title="file add" id="otherFile5"
                        accept="image/jpg, image/jpeg, image/png, application/pdf" />
                      <label> <input type='text' class='input_text'
                        readonly='readonly' id='otherFileTxt5' /> <!-- <span class='label_text'>
                        <a href='#'>Upload</a>
                      </span>
                      <span class='label_text'>
                        <a href='#' onclick='fn_removeFile("OTH5")'>Remove</a>
                      </span> -->
                      </label>
                    </div>
                  </td>
                </tr>
                <tr>
                  <td colspan=2><span class="red_text"><spring:message
                        code="supplement.text.picFormatNotice" /> </span></td>
                </tr>
              </tbody>
            </table>
          </section>
</article>