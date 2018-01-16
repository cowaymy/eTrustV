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
/* 특정 칼럼 드랍 리스트 왼쪽 정렬 재정의*/
#course_grid_wrap-aui-grid-drop-list-stusCodeId .aui-grid-drop-list-ul {
     text-align:left;
 }
#attendee_grid_wrap-aui-grid-drop-list-coursTestResult .aui-grid-drop-list-ul {
     text-align:left;
 }
#attendee_grid_wrap-aui-grid-drop-list-coursMemShirtSize .aui-grid-drop-list-ul {
     text-align:left;
 }
#attendee_grid_wrap-aui-grid-drop-list-coursItmMemPup .aui-grid-drop-list-ul {
     text-align:left;
 }
#attendee_grid_wrap-aui-grid-drop-list-coursItmMemIsVege .aui-grid-drop-list-ul {
     text-align:left;
 }
</style>
<script type="text/javascript">
//그리드에 삽입된 데이터의 전체 길이 보관
var gridDataLength = 0;
var gridId = null;
var rIndex = 0;
var coursId = 0;
var timerId = null;
var keyValueList = $.parseJSON('${courseStatusList}');
var courseColumnLayout = [ {
    dataField : "coursId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "codeId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
},{
    dataField : "codeName",
    headerText : 'Course Type',
    editable : false,
    style : "aui-grid-user-custom-left"
}, {
    dataField : "coursCode",
    headerText : 'Course Code',
    editable : false
}, {
    dataField : "coursName",
    headerText : 'Course Name',
    editable : false,
    style : "aui-grid-user-custom-left"
}, {
	dataField : "coursLoc",
    headerText : 'Location',
    editable : false,
    style : "aui-grid-user-custom-left"
}, {
    dataField : "coursLimit",
    headerText : 'Limit',
    dataType : "numeric",
    style : "aui-grid-user-custom-right",
    editable : true
}, {
    dataField : "coursStart",
    headerText : 'Start',
    editable : false
}, {
    dataField : "coursEnd",
    headerText : 'End',
    editable : false
}, {
    dataField : "total",
    headerText : 'Applicants',
    editable : false,
    dataType : "numeric",
    style : "aui-grid-user-custom-right"
}, {
    dataField : "passed",
    headerText : 'Passed',
    editable : false,
    dataType : "numeric",
    style : "aui-grid-user-custom-right"
} , {
    dataField : "stusCodeId",
    headerText : 'Status',
    editable : false,
    renderer : {
        type : "DropDownListRenderer",
        list : keyValueList, //key-value Object 로 구성된 리스트
        keyField : "stusCodeId", // key 에 해당되는 필드명
        valueField : "name" // value 에 해당되는 필드명
    }
}
];

//그리드 속성 설정
var courseGridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    editable : true,
    selectionMode : "singleRow"
};

var courseGridID;

var attendeeColumnLayout = [ {
    dataField : "isActive",
    headerText : '<input type="checkbox" id="allCheckbox" style="width:15px;height:15px;">',
    width: 30,
    renderer : {
        type : "CheckBoxEditRenderer",
        showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
        editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
        checkValue : "Active", // true, false 인 경우가 기본
        unCheckValue : "Inactive"
    }
}, {
	dataField : "",
    headerText : 'No.',
    dataType: "numeric",
    width : 40,
    expFunction : function( rowIndex, columnIndex, item, dataField ) { // 여기서 실제로 출력할 값을 계산해서 리턴시킴.
        // expFunction 의 리턴형은 항상 Number 여야 합니다.(즉, 수식만 가능)
        return rowIndex + 1;
    }
}, {
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
    editable : false
}, {
    dataField : "memCode",
    headerText : 'Member Code',
    editable : false,
    colSpan : 2
}, {
    dataField : "",
    headerText : '',
    width: 30,
    renderer : {
        type : "IconRenderer",
        iconTableRef :  {
            "default" : "${pageContext.request.contextPath}/resources/images/common/normal_search.png"// default
        },         
        iconWidth : 24,
        iconHeight : 24,
        onclick : function(rowIndex, columnIndex, value, item) {
        	rIndex = rowIndex;
        	gridId = attendeeGridID;
        	fn_searchUserIdPop();
            }
        },
    colSpan : -1
}, {
    dataField : "coursDMemName",
    headerText : 'Member Name',
    style : "aui-grid-user-custom-left",
}, {
    dataField : "coursDMemNric",
    headerText : 'NRIC',
    editable : false
}, {
    dataField : "brnchId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "code",
    headerText : 'Branch',
    editable : false
}, {
    dataField : "coursAttendDay",
    headerText : 'Attend Day',
    editable : true
}, {
    dataField : "coursTestResult",
    headerText : 'Result',
    renderer : {
        type : "DropDownListRenderer",
        list : [{"coursTestResult":"P","name":"Pass"},{"coursTestResult":"F","name":"Fail"},{"coursTestResult":"AB","name":"Absent"}], //key-value Object 로 구성된 리스트
        keyField : "coursTestResult", // key 에 해당되는 필드명
        valueField : "name" // value 에 해당되는 필드명
    }
}//, {
//    dataField : "coursMemShirtSize",
//    headerText : 'Shirt Size',
//    renderer : {
//        type : "DropDownListRenderer",
//        list : [{"coursMemShirtSize":"S","name":"S"},{"coursMemShirtSize":"M","name":"M"},{"coursMemShirtSize":"L","name":"L"},{"coursMemShirtSize":"XL","name":"XL"},{"coursMemShirtSize":"XXL","name":"XXL"},{"coursMemShirtSize":"XXXL","name":"XXXL"}], //key-value Object 로 구성된 리스트
//        keyField : "coursMemShirtSize", // key 에 해당되는 필드명
//        valueField : "name" // value 에 해당되는 필드명
//    }
//}, {
//    dataField : "coursItmMemPup",
//    headerText : 'PUP',
//    renderer : {
//        type : "DropDownListRenderer",
//        list : [{"coursItmMemPup":"344","name":"Central"},{"coursItmMemPup":"345","name":"Northen"},{"coursItmMemPup":"346","name":"Southern"}], //key-value Object 로 구성된 리스트
//        keyField : "coursItmMemPup", // key 에 해당되는 필드명
//        valueField : "name" // value 에 해당되는 필드명
//    }
//}, {
//    dataField : "coursItmMemIsVege",
//    headerText : 'IS VEG?',
//    renderer : {
//        type : "DropDownListRenderer",
//        list : [{"coursItmMemIsVege":"1","name":"Yes"},{"coursItmMemIsVege":"0","name":"No"}], //key-value Object 로 구성된 리스트
//        keyField : "coursItmMemIsVege", // key 에 해당되는 필드명
//        valueField : "name" // value 에 해당되는 필드명
//    }
//}
];

//그리드 속성 설정
var attendeeGridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    showRowNumColumn : false,
    editable : true,
    softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
    softRemoveRowMode : false
};

var attendeeGridID;

$(document).ready(function () {
	courseGridID = AUIGrid.create("#course_grid_wrap", courseColumnLayout, courseGridPros);
	attendeeGridID = AUIGrid.create("#attendee_grid_wrap", attendeeColumnLayout, attendeeGridPros);
	
	fn_setAttendeeGridCheckboxEvent();
	
	// course status
    CommonCombo.make("stusCodeId", "/organization/training/selectCourseStatusList.do", null, "", {
        id: "stusCodeId",
        name: "name",
        type:"S"
    });
	
	// course type
	CommonCombo.make("codeId", "/organization/training/selectCourseTypeList.do", null, "", {
        id: "codeId",
        name: "codeName",
        type:"S"
    });
	
	// Memeber (Y/N)
    CommonCombo.make("generalCode", "/common/selectCodeList.do", {groupCode : '328'}, "", {
        id: "codeId",
        name: "code",
        isShowChoose: false,
        type:"S"
    });
    
    // Member Type
    CommonCombo.make("memType", "/common/selectCodeList.do", {groupCode : '1', codeIn : 'HP,CD,CT,ST'}, "", {
        id: "codeId",
        name: "codeName",
        type:"S"
    });
    
	// search list
	$("#search_btn").click(fn_selectCourseList);
	
	// view/edit popup
	// 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(courseGridID, "cellDoubleClick", function(event){
    	fn_courseViewPop(event.item.coursId);
    });

	AUIGrid.bind(courseGridID, "selectionChange", auiGridSelectionChangeHandler );

	$("#registration_btn").click(fn_courseNewPop);
//	$("#viewEdit_btn").click(fn_courseViewPop);
	$("#attendee_btn").click(function() {
		fn_attendeePop("");
	});
	$("#addRow_btn").click(function() {
		fn_addRow(attendeeGridID);
	});
	$("#delRow_btn").click(function() {
		fn_delRow(attendeeGridID);
	});
	$("#course_Save_btn").click(fn_courseSave);
	$("#attendee_save_btn").click(function() {
		fn_attendeeSave(attendeeGridID);
	});
	$("#result_btn").click(fn_courseResultPop);
	
	fn_setToDay();
});

function auiGridSelectionChangeHandler(event) { 
    // 200ms 보다 빠르게 그리드 선택자가 변경된다면 데이터 요청 안함
    if(timerId) {
        clearTimeout(timerId);
    }

    timerId = setTimeout(function() {
    	var selectedItems = event.selectedItems;
//        if(selectedItems.length <= 0)
//            return;
        
        var rowItem = selectedItems[0].item; // 행 아이템들
        var corId = rowItem.coursId; // 선택한 행의 고객 ID 값
        var corCode = rowItem.coursCode;
        $("#coursId").val(corId);
        $("#coursCodeR").val(corCode);
//        if(event.dataField != "coursLimit" && event.dataField != "stusCodeId") {

            fn_selectAttendeeList(corId);
            coursId = corId;
            
//        }
    }, 200);
}

function fn_setAttendeeGridCheckboxEvent() {
	// ready 이벤트 바인딩
    AUIGrid.bind(attendeeGridID, "ready", function(event) {
        gridDataLength = AUIGrid.getRowCount(attendeeGridID); // 그리드 전체 행수 보관
    });
    
    // 헤더 클릭 핸들러 바인딩
    AUIGrid.bind(attendeeGridID, "headerClick", headerClickHandler);
    
    // 셀 수정 완료 이벤트 바인딩
    AUIGrid.bind(attendeeGridID, "cellEditEnd", function(event) {
        
        // isActive 칼럼 수정 완료 한 경우
        if(event.dataField == "isActive") {
            
            // 그리드 데이터에서 isActive 필드의 값이 Active 인 행 아이템 모두 반환
            var activeItems = AUIGrid.getItemsByValue(attendeeGridID, "isActive", "Active");
            
            // 헤더 체크 박스 전체 체크 일치시킴.
            if(activeItems.length != gridDataLength) {
                document.getElementById("allCheckbox").checked = false;
            } else if(activeItems.length == gridDataLength) {
                 document.getElementById("allCheckbox").checked = true;
            }
        }
    });
}

//그리드 헤더 클릭 핸들러
function headerClickHandler(event) {
    
    // isActive 칼럼 클릭 한 경우
    if(event.dataField == "isActive") {
        if(event.orgEvent.target.id == "allCheckbox") { // 정확히 체크박스 클릭 한 경우만 적용 시킴.
            var  isChecked = document.getElementById("allCheckbox").checked;
            checkAll(isChecked);
        }
        return false;
    }
}

// 전체 체크 설정, 전체 체크 해제 하기
function checkAll(isChecked) {
    
     var idx = AUIGrid.getRowCount(attendeeGridID); 
    
    // 그리드의 전체 데이터를 대상으로 isActive 필드를 "Active" 또는 "Inactive" 로 바꿈.
    if(isChecked) {
        for(var i = 0; i < idx; i++){
        	//AUIGrid.updateAllToValue(invoAprveGridID, "isActive", "Active");
            AUIGrid.setCellValue(attendeeGridID, i, "isActive", "Active")
        }
    } else {
        AUIGrid.updateAllToValue(attendeeGridID, "isActive", "Inactive");
    }
    
    // 헤더 체크 박스 일치시킴.
    document.getElementById("allCheckbox").checked = isChecked;
}

function fn_setToDay() {
    var today = new Date();
    
    var dd = today.getDate();
    var mm = today.getMonth() + 1;
    var yyyy = today.getFullYear();
    
    if(dd < 10) {
        dd = "0" + dd;
    }
    if(mm < 10){
        mm = "0" + mm
    }
    
    today = dd + "/" + mm + "/" + yyyy;
    $("#coursStart").val(today)
    $("#coursEnd").val(today)
}

function fn_selectCourseList() {
	Common.ajax("GET", "/organization/training/selectCourseList.do?_cacheId=" + Math.random(), $("#form_course").serialize(), function(result) {
        console.log(result);
        AUIGrid.setGridData(courseGridID, result);
    });
	
	AUIGrid.destroy(attendeeGridID);
	attendeeGridID = AUIGrid.create("#attendee_grid_wrap", attendeeColumnLayout, attendeeGridPros);
	
	fn_setAttendeeGridCheckboxEvent();
}

function fn_courseViewPop(couseIdVal) {
	if(couseIdVal > 0) {
		var data = {
	            coursId : couseIdVal
	    };
	    Common.popupDiv("/organization/training/courseViewPop.do", data, null, true, "courseViewPop");
	    
	    coursId = 0;
    } else {
    	Common.alert('Please select a course.');
    }
}

function fn_selectAttendeeList(coursId) {
	var data = {
            coursId : coursId
    };
	Common.ajax("GET", "/organization/training/selectAttendeeList.do?_cacheId=" + Math.random(), data, function(result) {
        console.log(result);
        AUIGrid.setGridData(attendeeGridID, result);
    });
}

function fn_courseNewPop() {
	Common.popupDiv("/organization/training/courseNewPop.do", null, null, true, "courseNewPop");
}

function fn_checkMemberType() {
	var val = $("#generalCode").val();
	if(val == "2318") {
		$("#memType").removeAttr("disabled");
	} else {
		$("#memType").attr("disabled", "disabled");
	}
}

function fn_checkAttendance() {
	var val = $("#attendance").val();
	if(val == "2315") {
		$("#coursLimit").attr("readonly", "readonly");
		$("#coursLimit").val("9999");
		$("#newAttendee_btn").show();
	} else {
		$("#coursLimit").removeAttr("readonly");
		$("#coursLimit").val("");
		$("#newAttendee_btn").hide();
	}
}

function fn_attendeePop(pType) {
	var data = {
			pType : pType, coursId : coursId
	};
	Common.popupDiv("/organization/training/attendeePop.do", data, null, true, "attendeePop");
}

function fn_addRow(gridID) {
    AUIGrid.addRow(gridID, {}, "first");
}

function fn_delRow(gridID) {
	var rowIndexes = AUIGrid.getRowIndexesByValue(gridID, "isActive", "Active");
    console.log(rowIndexes);
	AUIGrid.removeRow(gridID, rowIndexes); // rowIndex 0, 1, 2 삭제(즉, 3개의 행 삭제)
}

function fn_searchUserIdPop() {
    Common.popupDiv("/common/memberPop.do", null, null, true);
}

// set 하는 function
function fn_loadOrderSalesman(memId, memCode) {

    Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {memId : memId, memCode : memCode}, function(memInfo) {

        if(memInfo == null) {
            Common.alert('<b>Member not found.</br>Your input member code : '+memCode+'</b>');
        }
        else {
            console.log(memInfo);
            // TODO createUser set
            // 0번째 행의 name 칼럼의 값을 "이름 고침" 으로 변경
            AUIGrid.setCellValue(gridId, rIndex, "memType", memInfo.memType);
            AUIGrid.setCellValue(gridId, rIndex, "memTypeName", memInfo.codeName);
            AUIGrid.setCellValue(gridId, rIndex, "coursMemId", memInfo.memId);
            AUIGrid.setCellValue(gridId, rIndex, "coursDMemName", memInfo.name);
            AUIGrid.setCellValue(gridId, rIndex, "coursDMemNric", memInfo.nric);
            
            Common.ajax("GET", "/organization/training/selectBranchByMemberId.do", {memId : memInfo.memId}, function(result) {
            	console.log(result);
            	
            	if(result.data) {
            		AUIGrid.setCellValue(gridId, rIndex, "brnchId", result.data.brnchId);
                    AUIGrid.setCellValue(gridId, rIndex, "code", result.data.code);
            	}
            	
            	gridId = null;
                rIndex = 0;
            });
        }
    });
}

function fn_courseSave() {
	console.log(GridCommon.getEditData(courseGridID));
	if(GridCommon.getEditData(courseGridID).update.length > 0) {
		Common.ajax("POST", "/organization/training/updateCourseForLimitStatus.do", GridCommon.getEditData(courseGridID), function(result) {
	        console.log(result);
	        
	        fn_selectCourseList();
	        
	        Common.alert('Saved successfully.');
	    });
	} else {
		Common.alert('Modified data not found.');
	}
}

function fn_attendeeSave(gridID) {
	console.log(GridCommon.getEditData(gridID));
	if(coursId > 0) {
		var data = {
				coursId : coursId,
				gridData : GridCommon.getEditData(gridID)
		};
		Common.ajax("POST", "/organization/training/updateAttendee.do", data, function(result) {
	        console.log(result);
	        
	        fn_selectAttendeeList(coursId);
	        
	        Common.alert('Saved successfully.');
	        
	        //coursId = 0;
	    });
	} else {
		Common.alert('Course not selected.');
	}
}

function fn_courseResultPop() {
    if(coursId > 0) {
        var data = {
                coursId : coursId
        };
        Common.popupDiv("/organization/training/courseResultPop.do", data, null, true, "courseResultPop");
        
        coursId = 0;
    } else {
        Common.alert('Please select a course.');
    }
}

function fn_generate(method){
	
	if($("#coursId").val() == ""){
		Common.alert("Please select the item to print.");
	}
	//CURRENT DATE
    var date = new Date().getDate();
	var mon = new Date().getMonth()+1;
	
    if(date.toString().length == 1){
        date = "0" + date;
    }
    
    if(mon.toString().length == 1){
        mon = "0" + mon;
    }
    
	//VIEW
    if(method == "PDF"){
        $("#viewType").val('PDF');     //method
        $("#reportFileName").val('/organization/training/HPTrainingReport_PDF.rpt'); //File Name
    }
    if(method == "EXCEL"){
        $("#viewType").val('EXCEL');//method
        $("#reportFileName").val('/organization/training/HPTrainingReport_Excel.rpt'); //File Name
    }
    
    $("#reportDownFileName").val($("#coursCodeR").val() +'_'+date+mon+new Date().getFullYear()); ////DOWNLOAD FILE NAME
    
    //params
    $("#V_COURSEID").val($("#coursId").val());
    $("#V_SELECTSQL").val("");
    $("#V_WHERESQL").val("");
    $("#V_EXTRAWHERESQL").val("");
    $("#V_ORDERBYSQL").val("");
    $("#V_FULLSQL").val("");
    
    var option = {
        isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };

    Common.report("dataForm", option);

}

$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if (type === 'checkbox' || type === 'radio'){
            this.checked = false;
        }else if (tag === 'select'){
            this.selectedIndex = -1;
        }
    });
};

</script>

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Course Management</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" id="registration_btn"><span class="new"></span>New</a></p></li>
	<c:if test="${PAGE_AUTH.funcView == 'Y'}">
	<li><p class="btn_blue"><a href="#" id="search_btn"><span class="search"></span>Search</a></p></li>
	</c:if>
	<li><p class="btn_blue"><a href="#" onclick="javascript:$('#form_course').clearForm();"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="dataForm" name="dataForm">
    <input type="hidden" id="reportFileName" name="reportFileName" />
    <input type="hidden" id="viewType" name="viewType" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" />
    <!--param  -->
    <input type="hidden" id="V_COURSEID" name="V_COURSEID"  />
    <input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL"  />
    <input type="hidden" id="V_WHERESQL" name="V_WHERESQL"  />
    <input type="hidden" id="V_EXTRAWHERESQL" name="V_EXTRAWHERESQL"  />
    <input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL"  />
    <input type="hidden" id="V_FULLSQL" name="V_FULLSQL"  />
</form>
<form action="#" method="post" id="form_course" name="form_course">
<input type="hidden" id="coursId" name="coursId"  />
<input type="hidden" id="coursCodeR" name="coursCodeR"  />
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:130px" />
	<col style="width:*" />
	<col style="width:170px" />
	<col style="width:*" />
	<col style="width:130px" />
	<col style="width:*" />
</colgroup>
<tbody>
<!-- <tr>
	<th scope="row">Course Code</th>
	<td>
	<input type="text" title="Course Code" placeholder="" class="w100p" id="coursCode" name="coursCode"/>
	</td>
	<th scope="row">Course Status</th>
	<td>
	<select class="w100p" id="stusCodeId" name="stusCodeId">
	</select>
	</td>
	<th scope="row">Course Type</th>
	<td>
	<select class="w100p" id="codeId" name="codeId">
	</select>
	</td>
</tr>
 -->
 <tr>
    <th scope="row">Course Type</th>
    <td>
    <select class="w100p" id="codeId" name="codeId">
    </select>
    </td>
    <th scope="row">Member(Y/N)/Type</th>
    <td>
    <select class="w23_5p" id="generalCode" name="generalCode">
    </select>
    <select class="ml5"  style="width: 73%"  id="memType" name="memType">
    </select>
    </td>
    <th scope="row">Effective date</th>
    <td>
        <div class="date_set"><!-- date_set start -->
        <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="coursStart" name="coursStart" value="${courseInfo.coursStart}"/></p>
<!--         <span>To</span>
        <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="newCoursEnd" name="coursEnd" value="${courseInfo.coursEnd}"/></p>
-->
        </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Course Status</th>
    <td>
    <select class="w100p" id="stusCodeId" name="stusCodeId">
    </select>
    </td>
	<th scope="row">Course Name</th>
	<td>
	<input type="text" title="Course Name" placeholder="" class="w100p" id="coursName" name="coursName"/>
	</td>
	<th scope="row">Course Code</th>
    <td>
    <input type="text" title="Course Code" placeholder="" class="w100p" id="coursCode" name="coursCode"/>
    </td>
<!-- 
	<th scope="row">Location</th>
	<td>
	<input type="text" title="Location" placeholder="" class="w100p" id="coursLoc" name="coursLoc"/>
	</td>
	<th scope="row">Training Period</th>
	<td>
	<div class="date_set"><!-- date_set start --
	<p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="coursStart" name="coursStart"/></p>
	<span>To</span>
	<p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="coursEnd" name="coursEnd"/></p>
	</div><!-- date_set end --
	</td>
-->
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
</c:if>
<dl class="link_list">
	<dt>Link</dt>
	<dd>
	<ul class="btns">
		<li><p class="link_btn"><a href="#" onclick="javascript:fn_generate('PDF');">Course Report (PDF)</a></p></li>
		<li><p class="link_btn"><a href="#" onclick="javascript:fn_generate('EXCEL');">Course Report (Excel)</a></p></li>
 	    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
	</dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<aside class="title_line"><!-- title_line start -->
<h4>Course List</h4>
<ul class="right_btns">
    <!-- <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li> 
    <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
    <li><p class="btn_grid"><a href="#" id="viewEdit_btn">Edit</a></p></li>
   <li><p class="btn_grid"><a href="#" id="registration_btn">New</a></p></li>-->
    <li><p class="btn_grid"><a href="#" id="result_btn">Result</a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_grid"><a href="#" id="course_Save_btn">Save</a></p></li>
    </c:if>
</ul>
</aside><!-- title_line end -->

<article class="grid_wrap" id="course_grid_wrap" style="width:100%; height:200px; margin:0 auto;"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

<aside class="title_line" style="margin-top:10px;"><!-- title_line start -->
<h4>Attendee List</h4>
<ul class="right_btns">
    <!-- <li><p class="btn_grid"><a href="#" id="attendee_btn">Attendee</a></p></li> -->
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_grid"><a href="#" id="addRow_btn">Add</a></p></li>
    <li><p class="btn_grid"><a href="#" id="delRow_btn">Del</a></p></li>
    <li><p class="btn_grid"><a href="#" id="attendee_save_btn">Save</a></p></li>
    </c:if>
</ul>
</aside><!-- title_line end -->

<article class="grid_wrap" id="attendee_grid_wrap" style="width:100%; height:200px; margin:0 auto;"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
