<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-right {
    text-align:right;
}
/* 커스텀 행 스타일 */
.my-row-style {
    background:#9FC93C;
    font-weight:bold;
    color:#22741C;
}
</style>
<script type="text/javascript">
//그리드에 삽입된 데이터의 전체 길이 보관
var atteRgistGridDataLength = 0;
function setInputFile(){//인풋파일 세팅하기
    $(".auto_file").append("<label><span class='label_text'><a href='#'>File</a></span><input type='text' class='input_text' readonly='readonly' /></label>");
}

var uploadGrid;
var atteRgistGridID;

$(document).ready(function() {
	$("#atteRgistUpload_btn").click(function() {
		fn_setGridDataByUploadData("${pType}");
	});
    
	setInputFile();
    
	$("#uploadGrid").hide();
    // 최초 그리드 생성함.
    createInitGrid();
    
 // ready 이벤트 바인딩
    AUIGrid.bind(atteRgistGridID, "ready", function(event) {
    	atteRgistGridDataLength = AUIGrid.getGridData(atteRgistGridID).length; // 그리드 전체 행수 보관
    });
    
    // 헤더 클릭 핸들러 바인딩
    AUIGrid.bind(atteRgistGridID, "headerClick", atteRgistHeaderClickHandler);
    
    // 셀 수정 완료 이벤트 바인딩
    AUIGrid.bind(atteRgistGridID, "cellEditEnd", function(event) {
        
        // isActive 칼럼 수정 완료 한 경우
        if(event.dataField == "isActive") {
            
            // 그리드 데이터에서 isActive 필드의 값이 Active 인 행 아이템 모두 반환
            var activeItems = AUIGrid.getItemsByValue(atteRgistGridID, "isActive", "Active");
            
            // 헤더 체크 박스 전체 체크 일치시킴.
            if(activeItems.length != atteRgistGridDataLength) {
                document.getElementById("atteRgistAllCheckbox").checked = false;
            } else if(activeItems.length == gridDataLength) {
                 document.getElementById("atteRgistAllCheckbox").checked = true;
            }
        }
    });
    
    // IE10, 11은 readAsBinaryString 지원을 안함. 따라서 체크함.
    var rABS = typeof FileReader !== "undefined" && typeof FileReader.prototype !== "undefined" && typeof FileReader.prototype.readAsBinaryString !== "undefined";

    // HTML5 브라우저인지 체크 즉, FileReader 를 사용할 수 있는지 여부
    function checkHTML5Brower() {
        var isCompatible = false;
        if (window.File && window.FileReader && window.FileList && window.Blob) {
            isCompatible = true;
        }
        return isCompatible;
    };
    
    // 파일 선택하기
    $('#fileSelector').on('change', function(evt) {
    	var data = null;
        var file = evt.target.files[0];
        if (typeof file == "undefined") {
            return;
        }
        
        var reader = new FileReader();
        //reader.readAsText(file); // 파일 내용 읽기
        reader.readAsText(file, "EUC-KR"); // 한글 엑셀은 기본적으로 CSV 포맷인 EUC-KR 임. 한글 깨지지 않게 EUC-KR 로 읽음
        reader.onload = function(event) {
            if (typeof event.target.result != "undefined") {
                                    
                // 그리드 CSV 데이터 적용시킴
                AUIGrid.setCsvGridData(uploadGrid, event.target.result, false);
                
                //csv 파일이 header가 있는 파일이면 첫번째 행(header)은 삭제한다.
                AUIGrid.removeRow(uploadGrid,0);
                
                fn_checkNewAttend();
                
            } else {
                alert('No data to import!');
            }
        };

        reader.onerror = function() {
            alert('Unable to read ' + file.fileName);
        };
    });
    
});

function fn_checkNewAttend(){
    var data = GridCommon.getGridData(uploadGrid);
    data.form = $("#form_atteRgist").serializeJSON();

    Common.ajax("POST", "/organization/training/chkNewAttendList.do", data, function(result)    {

        console.log("성공." + JSON.stringify(result));
        console.log("data : " + result.data);              
                                
        AUIGrid.setGridData(atteRgistGridID, result.data);
                
        AUIGrid.setProp(atteRgistGridID, "rowStyleFunction", function(rowIndex, item) {
            if(item.chkFlag == "Y") { 
                return "my-row-style";
            }
            return "";

        }); 

        // 변경된 rowStyleFunction 이 적용되도록 그리드 업데이트
        AUIGrid.update(atteRgistGridID);
                
        }
    , function(jqXHR, textStatus, errorThrown){
         try {
                console.log("Fail Status : " + jqXHR.status);
                console.log("code : "        + jqXHR.responseJSON.code);
                console.log("message : "     + jqXHR.responseJSON.message);
                console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
          }
          catch (e)
          {
              console.log(e);
          }
                  alert("Fail : " + jqXHR.responseJSON.message);
     });

}

//그리드 헤더 클릭 핸들러
function atteRgistHeaderClickHandler(event) {
    
    // isActive 칼럼 클릭 한 경우
    if(event.dataField == "isActive") {
        if(event.orgEvent.target.id == "atteRgistAllCheckbox") { // 정확히 체크박스 클릭 한 경우만 적용 시킴.
            var  isChecked = document.getElementById("atteRgistAllCheckbox").checked;
            atteRgistCheckAll(isChecked);
        }
        return false;
    }
}

// 전체 체크 설정, 전체 체크 해제 하기
function atteRgistCheckAll(isChecked) {
    
     var idx = AUIGrid.getRowCount(atteRgistGridID); 
    
    // 그리드의 전체 데이터를 대상으로 isActive 필드를 "Active" 또는 "Inactive" 로 바꿈.
    if(isChecked) {
        for(var i = 0; i < idx; i++){
            //AUIGrid.updateAllToValue(invoAprveGridID, "isActive", "Active");
            AUIGrid.setCellValue(atteRgistGridID, i, "isActive", "Active")
        }
    } else {
        AUIGrid.updateAllToValue(atteRgistGridID, "isActive", "Inactive");
    }
    
    // 헤더 체크 박스 일치시킴.
    document.getElementById("atteRgistAllCheckbox").checked = isChecked;
}

//IE10, 11는 바이너리스트링 못읽기 때문에 ArrayBuffer 처리 하기 위함.
function fixdata(data) {
 var o = "", l = 0, w = 10240;
 for(; l<data.byteLength/w; ++l) o+=String.fromCharCode.apply(null,new Uint8Array(data.slice(l*w,l*w+w)));
 o+=String.fromCharCode.apply(null, new Uint8Array(data.slice(l*w)));
 return o;
};

// 파싱된 시트의 CDATA 제거 후 반환.
function process_wb(wb) {
 var output = "";
 output = JSON.stringify(to_json(wb));

 output = output.replace( /<!\[CDATA\[(.*?)\]\]>/g, '$1' );
 return JSON.parse(output);
};

// 엑셀 시트를 파싱하여 반환
function to_json(workbook) {
 var result = {};
 workbook.SheetNames.forEach(function(sheetName) {
     var roa = XLSX.utils.sheet_to_row_object_array(workbook.Sheets[sheetName], {defval:""});
     
     if(roa.length > 0){
         result[sheetName] = roa;
     }
 });
 return result;
}

function setAUIGrid(jsonData) {
 
 var firstRow = jsonData;
 
 console.log(firstRow);
 
 if(typeof firstRow == "undefined") {
     Common.alert("* Can Convert File. Please Try Again.");
     $("#fileSelector").val("");
     return;
 }
 
    var gridArray = [];
    $.each(firstRow, function(key , value) {
    	var keyValue = {};
      $.each(value, function(k, v) {
            //console.log("key : " + k)
            if(k.trim() == "Member Name"){  //Template
            	keyValue.coursDMemName = v;
            }
            if(k.trim() == "NRIC"){  //Template
            	keyValue.coursDMemNric = v;
            }
            if(k.trim() == "Shirt Size"){  //Template
            	keyValue.coursMemShirtSize = v;
            }
            if(k.trim() == "PUP"){  //Template
            	keyValue.coursItmMemPup = v;
            }
            if(k.trim() == "IS VEG?"){  //Template
            	keyValue.coursItmMemIsVege = v;
            }
      });
      gridArray.push(keyValue);
    });
    console.log(gridArray);

    //template Chk
    if(gridArray == null || gridArray.length <= 0){
        Common.alert("* Template was Chaged. Please Try Again. ");
        $("#fileSelector").val("");
        return;
    }
 
    AUIGrid.setGridData(atteRgistGridID, gridArray);
}; //Create Grid End

//최초 그리드 생성..
function createInitGrid() {
 
	var upColLayout = [ {
        dataField : "0",
        headerText : "nric",
        width : 100
    },{
        dataField : "1",
        headerText : "result",
        width : 100
    }];
	
	var atteRgistColumnLayout = [
                        {dataField : "coursDMemName" , headerText : "Member Name", width : "20%",  editable : false },
                        {dataField : "coursDMemNric" , headerText : "NRIC", width : "20%",  editable : false },
                        {dataField : "coursMemShirtSize" , headerText : "Shirt Size", width : "20%",  editable : false },
                        {dataField : "coursItmMemPup" , headerText : "PUP", width : "20%",  editable : false },
                        {dataField : "coursItmMemIsVege" , headerText : "IS VEG?", width : "20%",  editable : false },
                        {dataField : "chkFlag" , visible : false },
                      ];
	var atteRgistGridPros = {
			showFooter : true
			};
	
	var upOptions = {
            showStateColumn:false,
            showRowNumColumn    : true,
            usePaging : false,
            editable : false,
            softRemoveRowMode:true
      };
	
	// 푸터 설정
    var footerObject = [ {
        labelText : "Total number",
        positionField : "coursItmMemPup"
    }, {
        dataField : "",
        positionField : "coursItmMemIsVege",
        formatString : "#,##0",
        style : "aui-grid-user-custom-right",
        /* value : operation 지정 한 경우 계산된 값,
         * columnValues : dataField 에 해당되는 모든 칼럼의 값들(Array),
         * footerValues : 푸터 전체 operation 수행된 값 또는 labelText 값 (Array)
         */
         labelFunction : function(value, columnValues, footerValues) {
             
             // 1월~3 최대값합 : footerValues[1], footerValues[2], footerValues[3] (푸터 설정 대로임)
             // 예를 들어 footerValues[0] 은 "사용자 정의 수식" 임.
             //var newValue = footerValues[1] + footerValues[2] + footerValues[3] - footerValues[4]; // 1~3 월 더한 후 (p1203(3월) 최대값 - 최소값) 빼줌
             
             return AUIGrid.getRowCount(atteRgistGridID);
         }
    }];
    uploadGrid = GridCommon.createAUIGrid("#uploadGrid", upColLayout, "", upOptions);
	atteRgistGridID = AUIGrid.create("#atteRgistGridID", atteRgistColumnLayout, atteRgistGridPros);
	// 푸터 객체 세팅
    AUIGrid.setFooter(atteRgistGridID, footerObject);
}

//HTML5 브라우저 즉, FileReader 를 사용 못할 경우 Ajax 로 서버에 보냄
//서버에서 파일 내용 읽어 반환 한 것을 통해 그리드에 삽입
//즉, 이것은 IE 10 이상에서는 불필요 (IE8, 9 에서만 해당됨)
function commitFormSubmit() {
    AUIGrid.showAjaxLoader(atteRgistGridID);
  
    // Submit 을 AJax 로 보내고 받음.
    // ajaxSubmit 을 사용하려면 jQuery Plug-in 인 jquery.form.js 필요함
    // 링크 : http://malsup.com/jquery/form/
  
    $('#form_atteRgist').ajaxSubmit({
       type : "json",
       success : function(responseText, statusText) {
           if(responseText != "error") {
               
               var csvText = responseText;
               console.log(csvText);
               
               // 기본 개행은 \r\n 으로 구분합니다.
               // Linux 계열 서버에서 \n 으로 구분하는 경우가 발생함.
               // 따라서 \n 을 \r\n 으로 바꿔서 그리드에 삽입
               // 만약 서버 사이드에서 \r\n 으로 바꿨다면 해당 코드는 불필요함. 
               csvText = csvText.replace(/\r?\n/g, "\r\n")
               console.log(csvText);
               
               // 그리드 CSV 데이터 적용시킴
               //AUIGrid.setCsvGridData(atteRgistGridID, csvText);
               
               AUIGrid.removeAjaxLoader(atteRgistGridID);
           }
       },
       error : function(e) {
           Common.alert("<spring:message code='sys.common.alert.error.ajaxSubmit' arguments='"+e+"' htmlEscape='false'/>");
       }
    });
}

function fn_setGridDataByUploadData(pType) {
	var atteRgistGridData = AUIGrid.getGridData(atteRgistGridID);
	console.log(atteRgistGridData);
	
	var idx = AUIGrid.getRowCount(atteRgistGridID);
	for(var i=0; i < idx; i++){
		if(AUIGrid.getCellValue(atteRgistGridID, i, "chkFlag") == "Y"){
	        Common.alert("Already registered NRIC.");
	    }
	}
	
	var nricArray = [];
	var gridArray = [];
    $.each(atteRgistGridData, function(key , value) {
        var keyValue = {};
        $.each(value, function(k, v) {
          //console.log("key : " + k)
        	if(k.trim() == "coursDMemNric"){  //Template
                nricArray.push(v);
            }
            if(k.trim() == "coursItmMemPup") {  //Template
                if(v.trim() == "Central") {
                    keyValue[k] = 344;
                } else if(v.trim() == "Northern") {
                    keyValue[k] = 345;
                } else if(v.trim() == "Southern") {
                    keyValue[k] = 346;
                }
            } else if(k.trim() == "coursItmMemIsVege") {  //Template
                if(v.trim() == "Yes") {
                    keyValue[k] = 1;
                } else {
                    keyValue[k] = 0;
                }
            } else {
                keyValue[k] = v;
            }
        });
        gridArray.push(keyValue);
    });
    console.log(gridArray);
	
    var jsonParam = { nricArray : nricArray};
    Common.ajax("GET", "/organization/training/getUploadMemList", jsonParam , function(result) {
        console.log(result)
    	
        if(result == null){
            Common.alert('<b>Member not found.</br>');
            $("#fileSelector").val("");
            return;
        }else{
        	
       var resultArray = [];
       $.each(result, function(key , value) {
    	   var resultMap = {};
           $.each(value, function(k, v) {
             //console.log("key : " + k)
             if(k.trim() == "coursDMemNric") {
            	 if(value[k] == gridArray[key][k]) {  //Template
            		 resultMap[k] = v;
                     resultMap.coursMemShirtSize = gridArray[key].coursMemShirtSize;
                     resultMap.coursItmMemPup = gridArray[key].coursItmMemPup;
                     resultMap.coursItmMemIsVege = gridArray[key].coursItmMemIsVege;
                 }
             } else {
            	 resultMap[k] = v;
             }
           });
           resultArray.push(resultMap);
       });
       console.log(resultArray);
       console.log(pType);
       if(pType == "new") {
    	   var newAttendeeGridData = AUIGrid.getGridData(newAttendeeGridID);
    	    console.log(newAttendeeGridData);
    	    var addArray = [];
            var updateArray = [];
    	   
          //Params Setting
            var strArr = [];
            for (var idx = 0; idx < newAttendeeGridData.length; idx++) {
               strArr.push(newAttendeeGridData[idx].coursDMemNric);   
            }
            
            $.each(resultArray, function(i , o) {
                var data = null;
                $.each(o, function(k, v) {
                  //console.log("key : " + k)
                  if(k.trim() == "coursDMemNric") {
                      if(strArr.indexOf(v) == -1){
                          //console.log("el : " + el);
                          data = o;
                          addArray.push(data);
                      } else {
                          data = o;
                          updateArray.push(data);
                      }
                  }
                });
            });
            
    	    if(addArray.length > 0) {
                console.log("add");
                console.log(addArray);
                AUIGrid.addRow(newAttendeeGridID, addArray, "last");
            }
            if(updateArray.length > 0) {
            	console.log("update");
                console.log(updateArray);
                for (var idx = 0; idx < updateArray.length; idx++) {
                	console.log("updateArray[idx]");
                	console.log(updateArray[idx]);
                	var rows = AUIGrid.getRowIndexesByValue(newAttendeeGridID, "coursDMemNric", updateArray[idx].coursDMemNric);
                	console.log("rows");
                	console.log(rows);
                	AUIGrid.updateRow(newAttendeeGridID, updateArray[idx], rows[0]);
                }
            }
            
    	   $("#attendeePop").remove();
       } else {
    	   var atteRgistGridData = AUIGrid.getGridData(attendeeGridID);
    	    console.log(attendeeGrid);
    	    var addArray = [];
            var updateArray = [];
            
          //Params Setting
            var strArr = [];
            for (var idx = 0; idx < atteRgistGridData.length; idx++) {
               strArr.push(atteRgistGridData[idx].coursDMemNric);   
            }
            
            $.each(resultArray, function(i , o) {
                var data = null;
                $.each(o, function(k, v) {
                  //console.log("key : " + k)
                  if(k.trim() == "coursDMemNric") {
                      if(strArr.indexOf(v) == -1){
                          //console.log("el : " + el);
                          data = o;
                          addArray.push(data);
                      } else {
                          data = o;
                          updateArray.push(data);
                      }
                  }
                });
            });
            
            if(addArray.length > 0) {
            	console.log("add");
                console.log(addArray);
            	//AUIGrid.addRow(attendeeGridID, resultArray, "last");
            }
            if(updateArray.length > 0) {
            	console.log("update");
            	console.log(updateArray);
            }
            
    	   $("#attendeePop").remove();
       }
    }
  });
	
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Attendee Registration</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<!-- <aside class="title_line">title_line start
<h2>Attendee Registration</h2>
</aside>title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_atteRgist">
<input type="hidden" id="coursId" name="coursId" value="${coursId}">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:120px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">File<span class="must">*</span></th>
	<td>
		<div class="auto_file"><!-- auto_file start -->
		<input type="file" id="fileSelector" title="file add" accept=".xlsx"/>
		</div><!-- auto_file end -->
		<p class="btn_sky"><a href="${pageContext.request.contextPath}/resources/download/organization/training/AttendeeUploadTemplate.xlsx">Download Format</a></p>
	</td>
</tr>
</tbody>
</table>

</form>
</section><!-- search_table end -->

<!-- <aside class="title_line">title_line start
<ul class="right_btns">
	<li><p class="btn_grid"><a href="#" id="atteRgistAddRow_btn">Add</a></p></li>
	<li><p class="btn_grid"><a href="#" id="atteRgistDelRow_btn">Del</a></p></li>
</ul>
</aside>title_line end -->

<article class="grid_wrap" id="atteRgist_grid_wrap"><!-- grid_wrap start -->
    <div id="uploadGrid" style="width:100%; height:250px; margin:0 auto;"></div>
    <div id="atteRgistGridID" style="width:100%; height:250px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
	<li><p class="btn_blue2 big"><a href="#" id="atteRgistUpload_btn">Upload</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->