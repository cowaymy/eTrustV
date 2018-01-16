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
 /* 버튼 스타일 재정의*/
.aui-grid-button-renderer {
     width:100%;
     padding: 4px;
 }
</style>
<script type="text/javascript">
//그리드에 삽입된 데이터의 전체 길이 보관
var gridDataLength = 0;
var gridId = null;
var rIndex = 0;
var coursId = 0;
var keyValueList = $.parseJSON('${courseStatusList}');
var courseColumnLayout = [ {
    dataField : "coursId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "codeId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "coursMemId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "coursDMemName",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "coursDMemNric",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "coursAttendOwner",
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
    dataField : "courseFromDate",
    headerText : 'Start',
    editable : false
}, {
    dataField : "courseToDate",
    headerText : 'End',
    editable : false
}, {
    dataField : "total",
    headerText : 'Applicants',
    editable : false,
    dataType : "numeric",
    style : "aui-grid-user-custom-right"
}, {
    dataField : "coursMemStusId",
    headerText : 'Course Status',
    editable : false
},{
    dataField : "undefined",
    headerText : "Request",
    width : 110,
    renderer : {
          type : "ButtonRenderer",
          labelText : "Request",
          onclick : function(rowIndex, columnIndex, value, item) {
               //pupupWin
              $("#coursId").val(item.coursId);
              $("#memId").val(item.coursMemId);
              $("#memName").val(item.coursDMemName);
              $("#memNric").val(item.coursDMemNric);
              $("#coursAttendOwner").val(item.coursAttendOwner);
              $("#coursMemStusId").val(item.coursMemStusId);
              $("#courseJoinCnt").val(item.courseJoinCnt);
              $("#coursLimit").val(item.coursLimit);
              fn_courseRequest();
          }
   }
},{
    dataField : "undefined",
    headerText : "Cancel",
    width : 110,
    renderer : {
          type : "ButtonRenderer",
          labelText : "Cancel",
          onclick : function(rowIndex, columnIndex, value, item) {
               //pupupWin
              $("#coursId").val(item.coursId);
              $("#memId").val(item.coursMemId);
              $("#coursAttendOwner").val(item.coursAttendOwner);
              $("#coursMemStusId").val(item.coursMemStusId);
              fn_courseCancel();
          }
   }
}];

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
    dataField : "coursMemId",
    headerText : 'Member Code'
}, {
    dataField : "coursDMemName",
    headerText : 'Member Name',
    style : "aui-grid-user-custom-left",
}, {
    dataField : "brnchId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "code",
    headerText : 'Branch',
}
];

//그리드 속성 설정
var attendeeGridPros = {
    // 페이징 사용       
    usePaging : true,
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20
};

var attendeeGridID;

$(document).ready(function () {
	courseGridID = AUIGrid.create("#course_grid_wrap", courseColumnLayout, courseGridPros);
	attendeeGridID = AUIGrid.create("#attendee_grid_wrap", attendeeColumnLayout, attendeeGridPros);
	
	fn_setAttendeeGridCheckboxEvent();
	
	// search list
	$("#search_btn").click(fn_selectCourseList);
	
	// view/edit popup
	AUIGrid.bind(courseGridID, "cellClick", function( event ) 
            {
                console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
                console.log("CellClick coursId : " + event.item.coursId);
                // TODO detail popup open
                if(event.dataField != "coursLimit" && event.dataField != "stusCodeId") {
                	fn_selectAttendeeList(event.item.coursId);
                    coursId = event.item.coursId;
                }
            });
	
	$("#registration_btn").click(fn_courseNewPop);
	$("#viewEdit_btn").click(fn_courseViewPop);
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

function fn_setAttendeeGridCheckboxEvent() {
	// ready 이벤트 바인딩
    AUIGrid.bind(attendeeGridID, "ready", function(event) {
        gridDataLength = AUIGrid.getGridData(attendeeGridID).length; // 그리드 전체 행수 보관
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
	Common.ajax("GET", "/organization/training/selectCourseRequestList.do", $("#form_course").serialize(), function(result) {
        console.log(result);
        AUIGrid.setGridData(courseGridID, result);
    });
	
	AUIGrid.destroy(attendeeGridID);
	attendeeGridID = AUIGrid.create("#attendee_grid_wrap", attendeeColumnLayout, attendeeGridPros);
	
	fn_setAttendeeGridCheckboxEvent();
}

function fn_courseViewPop() {
	if(coursId > 0) {
		var data = {
	            coursId : coursId
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
			pType : pType
	};
	Common.popupDiv("/organization/training/attendeePop.do", data, null, true, "attendeePop");
}

function fn_addRow(gridID) {
    AUIGrid.addRow(gridID, {}, "last");
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

function fn_courseRequest() {

	if($("#coursAttendOwner").val() == 2361){  //멤버
//		if($("#coursMemStusId").val() == 8){
//			등록가능
//		}else 
	   if($("#coursMemStusId").val() == 1){
		   Common.alert("Can not register");  //취소가능
		   return false;
		}
	}else if($("#coursAttendOwner").val() == 2315){    //교육팀
	    if($("#coursMemStusId").val() == 8){
	    	Common.alert("Can not register");
	    	return false;
        }
//	    else if($("#coursMemStusId").val() == 1){
//            취소불가
//        }
	}
	
	if($("#courseJoinCnt").val() >= $("#coursLimit").val()){
		Common.alert("Can not register");
	}
	
    Common.ajax("POST", "/organization/training/registerCourseReq.do", $("#form_course").serializeJSON(), function(result) {
        console.log(result);
        
        fn_selectCourseList();
        
        Common.alert('Request successful.');

    });
}

function fn_courseCancel() {

	if($("#coursAttendOwner").val() == 2361){  //멤버
        if($("#coursMemStusId").val() == 8){
        	Common.alert("Can not Cancel");    //등록가능
        	return false;
        }
//        else if($("#coursMemStusId").val() == 1){
//            취소가능
//        }
    }else if($("#coursAttendOwner").val() == 2315){    //교육팀
//        if($("#coursMemStusId").val() == 8){
//            등록불가
//        }else 
        	if($("#coursMemStusId").val() == 1){
            Common.alert("Can not Cancel");
            return false;
        }
    }
    
    Common.ajax("POST", "/organization/training/cancelCourseReq.do", $("#form_course").serializeJSON(), function(result) {
        console.log(result);
        
        fn_selectCourseList();
        
        Common.alert('Cancel successful.');
        
    });
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Course Request</h2>
<ul class="right_btns">
	<li><p class="btn_blue"><a href="#" id="search_btn"><span class="search"></span>Search</a></p></li>
	<!-- <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li> -->
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form method="post" id="form_course" name="form_course">
<input type="hidden" id="coursId" name="coursId">
<input type="hidden" id="memId" name="memId">
<input type="hidden" id="memName" name="memName">
<input type="hidden" id="memNric" name="memNric">
<input type="hidden" id="coursAttendOwner" name="coursAttendOwner">
<input type="hidden" id="coursMemStusId" name="coursMemStusId">
<input type="hidden" id="courseJoinCnt" name="courseJoinCnt">
<input type="hidden" id="coursLimit" name="coursLimit">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:130px" />
	<col style="width:*" />
	<col style="width:160px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Member CODE</th>
	<td>
	<input type="text" title="Member CODE" placeholder="" class="w100p readonly" id="memberCode" name="memberCode" value="${coursMemCode}"/>
	</td>
	<th scope="row">Effective date(from)</th>
	<td>
	   <input type="text" title="Start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="coursStart" name="coursStart"/>
	</td>
</tr>
</tbody>
</table><!-- table end -->

<%-- <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a href="#" id="courseReport_pdf_btn">Course Report (PDF)</a></p></li>
        <li><p class="link_btn"><a href="#" id="courseReport_excel_btn">Course Report (Excel)</a></p></li>
        <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end --> --%>

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<aside class="title_line"><!-- title_line start -->
<h4>Course List</h4>
<ul class="right_btns">
    <!-- <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li> -->
    <!-- <li><p class="btn_grid"><a href="#" id="viewEdit_btn">Edit</a></p></li>
   <li><p class="btn_grid"><a href="#" id="registration_btn">New</a></p></li>
    <li><p class="btn_grid"><a href="#" id="result_btn">Result</a></p></li> 
    <li><p class="btn_grid"><a href="#" id="course_Save_btn">Save</a></p></li>-->
</ul>
</aside><!-- title_line end -->

<article class="grid_wrap" id="course_grid_wrap" style="width:100%; height:200px; margin:0 auto;"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

<aside class="title_line" style="margin-top:10px;"><!-- title_line start -->
<h4>Attendee List</h4>
<ul class="right_btns">
    <!-- <li><p class="btn_grid"><a href="#" id="attendee_btn">Attendee</a></p></li> -->
    <!-- <li><p class="btn_grid"><a href="#" id="addRow_btn">Add</a></p></li>
    <li><p class="btn_grid"><a href="#" id="delRow_btn">Del</a></p></li>
    <li><p class="btn_grid"><a href="#" id="attendee_save_btn">Save</a></p></li> -->
</ul>
</aside><!-- title_line end -->

<article class="grid_wrap" id="attendee_grid_wrap" style="width:100%; height:200px; margin:0 auto;"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->