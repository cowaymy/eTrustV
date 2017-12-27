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
</style>
<script type="text/javascript">
var courseReColumnLayout = [ {
    dataField : "coursId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "codeId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
},{
    dataField : "codeName",
    headerText : 'Course Type',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "coursCode",
    headerText : 'Course Code',
}, {
    dataField : "coursName",
    headerText : 'Course Name',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "coursLoc",
    headerText : 'Location',
    style : "aui-grid-user-custom-left"
}, {
    dataField : "coursLimit",
    headerText : 'Limit',
    dataType : "numeric",
    style : "aui-grid-user-custom-right",
}, {
    dataField : "coursStart",
    headerText : 'Start',
}, {
    dataField : "coursEnd",
    headerText : 'End',
}, {
    dataField : "total",
    headerText : 'Applicants',
    dataType : "numeric",
    style : "aui-grid-user-custom-right"
}, {
    dataField : "passed",
    headerText : 'Passed',
    dataType : "numeric",
    style : "aui-grid-user-custom-right"
}, {
    dataField : "stusCodeId",
    headerText : 'Status',  
    labelFunction : function(rowIndex, columnIndex, value, headerText, item, dataField) {
    	   var myString = "";
    	   if(value == "1") {
    		   myString = "Active";
    	   } else if(value == "3") {
    		   myString = "Terminated";
    	   } else {
    		   myString = "Completed";
    	   }
    	   // 로직 처리
    	   // 여기서 value 를 원하는 형태로 재가공 또는 포매팅하여 반환하십시오.
    	   return myString;
    	} 
}
];

//그리드 속성 설정
var courseReGridPros = {
    showRowNumColumn : false,
    height : 55
};

var courseReGridID;

var attendeeReColumnLayout = [ {
    dataField : "coursItmId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "coursId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "memType",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "memTypeName",
    headerText : 'Member Type',
}, {
    dataField : "memCode",
    headerText : 'Member Code'
}, {
    dataField : "coursDMemName",
    headerText : 'Member Name',
    style : "aui-grid-user-custom-left",
}, {
    dataField : "coursDMemNric",
    headerText : 'NRIC',
}, {
    dataField : "brnchId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "code",
    headerText : 'Branch',
}, {
    dataField : "coursAttendDay",
    headerText : 'Course Attend Day',
}, {
    dataField : "coursTestResult",
    headerText : 'Result',
    renderer : {
        type : "DropDownListRenderer",
        list : [{"coursTestResult":"P","name":"Pass"},{"coursTestResult":"F","name":"Fail"},{"coursTestResult":"AB","name":"Absent"}], //key-value Object 로 구성된 리스트
        keyField : "coursTestResult", // key 에 해당되는 필드명
        valueField : "name" // value 에 해당되는 필드명
    }
}
];

//그리드 속성 설정
var attendeeReGridPros = {
		showFooter : true
};

var attendeeReGridID;

//푸터 설정
var footerObject = [ {
    labelText : "Total number",
    positionField : "code"
}, {
    dataField : "",
    positionField : "coursTestResult",
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
         
         return AUIGrid.getRowCount(attendeeReGridID);
     }
}];

function setInputFile(){//인풋파일 세팅하기
    $(".auto_file").append("<label><span class='label_text'><a href='#'>File</a></span><input type='text' class='input_text' readonly='readonly' /></label>");
}

$(document).ready(function () {
	courseReGridID = AUIGrid.create("#courseRe_grid_wrap", courseReColumnLayout, courseReGridPros);
    attendeeReGridID = AUIGrid.create("#attendeeRe_grid_wrap", attendeeReColumnLayout, attendeeReGridPros);
    
 // 푸터 객체 세팅
    AUIGrid.setFooter(attendeeReGridID, footerObject);
    
    setInputFile();
    
    AUIGrid.setGridData(courseReGridID, $.parseJSON('${courseInfo}'));
    AUIGrid.setGridData(attendeeReGridID, $.parseJSON('${attendeeList}'));
    
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
        if (!checkHTML5Brower()) {
            Common.alert("* Not Support HTML5 your Browser!. Please Upload To Server.");
            return;
            
            // 브라우저가 FileReader 를 지원하지 않으므로 Ajax 로 서버로 보내서
            // 파일 내용 읽어 반환시켜 그리드에 적용.
            //commitFormSubmit();
        } else {
            var data = null;
            var file = evt.target.files[0];
            if (typeof file == "undefined") {
                Common.alert("* can not Select this File.");
                return;
            }
            var reader = new FileReader();

            reader.onload = function(e) {
                var data = e.target.result;

                /* 엑셀 바이너리 읽기 */
                var workbook;

                if(rABS) { // 일반적인 바이너리 지원하는 경우
                    workbook = XLSX.read(data, {type: 'binary'});
                } else { // IE 10, 11인 경우
                    var arr = fixdata(data);
                    workbook = XLSX.read(btoa(arr), {type: 'base64'});
                }

                var jsonObj = process_wb(workbook);

                setAUIGrid( jsonObj[Object.keys(jsonObj)[0]] );
            };

            if(rABS) reader.readAsBinaryString(file);
            else reader.readAsArrayBuffer(file);
            
        }
    });
    
    $("#reSave_btn").click(fn_courseResultSave);
});

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
            console.log("key : " + k);
            console.log("key : " + v);
            if(k.trim() == "NRIC"){  //Template
                keyValue.coursDMemNric = v;
            }
            if(k.trim() == "ATTEND_DAY"){  //Template
                keyValue.coursAttendDay = v;
            }
            if(k.trim() == "Result"){  //Template
                keyValue.coursTestResult = v;
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
 
    fn_setGridDataByUploadData(gridArray);
}; //Create Grid End

function fn_setGridDataByUploadData(array) {
	var attendeeReGridData = AUIGrid.getGridData(attendeeReGridID);
    console.log(attendeeReGridData);
    
  //Params Setting
    var strArr = [];
    for (var idx = 0; idx < attendeeReGridData.length; idx++) {
       strArr.push(attendeeReGridData[idx].coursDMemNric);   
    }
    
    var existArray = [];
    $.each(array, function(i , o) {
        var data = null;
        $.each(o, function(k, v) {
          //console.log("key : " + k)
          if(k.trim() == "coursDMemNric") {
              if(strArr.indexOf(v) != -1){
                  //console.log("el : " + el);
                  data = o;
                  existArray.push(data);
              }
          }
        });
    });
    
    if(existArray.length > 0) {
        console.log("update");
        console.log(existArray);
        for (var idx = 0; idx < existArray.length; idx++) {
            console.log("existArray[idx]");
            console.log(existArray[idx]);
            var rows = AUIGrid.getRowIndexesByValue(attendeeReGridID, "coursDMemNric", existArray[idx].coursDMemNric);
            console.log("rows");
            console.log(rows);
            
            var upperResult = existArray[idx].coursTestResult.toUpperCase();
            var attendDay = Number(existArray[idx].coursAttendDay);

            if(upperResult != "P" && upperResult != "F" && upperResult != "AB"){
            	Common.alert("Invalid Result Code.");
            	return false;
            }
            
            if(attendDay < 0 ){
            	Common.alert("Can not key-in Minus day");
                return false;
            }
            
            AUIGrid.setCellValue(attendeeReGridID, rows[0], "coursTestResult", existArray[idx].coursTestResult);
            AUIGrid.setCellValue(attendeeReGridID, rows[0], "coursAttendDay", existArray[idx].coursAttendDay);
        }
    }
}

function fn_courseResultSave() {
	var data = {
            coursId : AUIGrid.getCellValue(courseReGridID, 0, "coursId"),
            gridData : GridCommon.getEditData(attendeeReGridID)
    };
	console.log(data);
    Common.ajax("POST", "/organization/training/updateAttendee.do", data, function(result) {
        console.log(result);
        
        fn_selectCourseList();
        fn_selectAttendeeList(AUIGrid.getCellValue(courseReGridID, 0, "coursId"));
        
        Common.alert('Saved successfully.');
        
        $("#courseResultPop").remove();
    });
}
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Result key-in</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h2>Course Information</h2>
</aside><!-- title_line end -->

<article class="grid_wrap" id="courseRe_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2>Result Upload</h2>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

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
		<input type="file" id="fileSelector" title="file add" accept=".csv" />
		</div><!-- auto_file end -->
		<p class="btn_sky"><a href="${pageContext.request.contextPath}/resources/download/organization/training/ResultKeyInUploadTemplate.xlsx">Download Format</a></p>
	</td>
</tr>
</tbody>
</table>

</form>
</section><!-- search_table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Attendee List</h2>
<!-- <ul class="right_btns">
	<li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
</ul> -->
</aside><!-- title_line end -->

<article class="grid_wrap" id="attendeeRe_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

<ul class="center_btns">
	<li><p class="btn_blue2 big"><a href="#" id="reSave_btn">Save</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->