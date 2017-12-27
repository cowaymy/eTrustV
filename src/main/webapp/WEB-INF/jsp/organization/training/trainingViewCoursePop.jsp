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
//그리드에 삽입된 데이터의 전체 길이 보관
var newGridDataLength = 0;
var newAttendeeColumnLayout = [ {
    dataField : "isActive",
    headerText : '<input type="checkbox" id="newAllCheckbox" style="width:15px;height:15px;">',
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
}, {
    dataField : "memCode",
    headerText : 'Member Code',
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
}, {
    dataField : "brnchId",
    visible : false // Color 칼럼은 숨긴채 출력시킴
}, {
    dataField : "code",
    headerText : 'Branch',
}, {
    dataField : "coursMemShirtSize",
    headerText : 'Shirt Size',
    renderer : {
        type : "DropDownListRenderer",
        list : [{"coursMemShirtSize":"S","name":"S"},{"coursMemShirtSize":"M","name":"M"},{"coursMemShirtSize":"L","name":"L"},{"coursMemShirtSize":"XL","name":"XL"},{"coursMemShirtSize":"XXL","name":"XXL"},{"coursMemShirtSize":"XXXL","name":"XXXL"}], //key-value Object 로 구성된 리스트
        keyField : "coursMemShirtSize", // key 에 해당되는 필드명
        valueField : "name" // value 에 해당되는 필드명
    }
}, {
    dataField : "coursItmMemPup",
    headerText : 'PUP',
    renderer : {
        type : "DropDownListRenderer",
        list : [{"coursItmMemPup":"344","name":"Central"},{"coursItmMemPup":"345","name":"Northen"},{"coursItmMemPup":"346","name":"Southern"}], //key-value Object 로 구성된 리스트
        keyField : "coursItmMemPup", // key 에 해당되는 필드명
        valueField : "name" // value 에 해당되는 필드명
    }
}, {
    dataField : "coursItmMemIsVege",
    headerText : 'IS VEG?',
    renderer : {
        type : "DropDownListRenderer",
        list : [{"coursItmMemIsVege":"1","name":"Yes"},{"coursItmMemIsVege":"0","name":"No"}], //key-value Object 로 구성된 리스트
        keyField : "coursItmMemIsVege", // key 에 해당되는 필드명
        valueField : "name" // value 에 해당되는 필드명
    }
}
];

//그리드 속성 설정
var newAttendeeGridPros = {
		// 페이징 사용       
	    usePaging : true,
	    // 한 화면에 출력되는 행 개수 20(기본값:20)
	    pageRowCount : 20,
	    showRowNumColumn : false,
	    softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
	    softRemoveRowMode : false
};

var newAttendeeGridID;

$(document).ready(function () {
    newAttendeeGridID = AUIGrid.create("#newAttendee_grid_wrap", newAttendeeColumnLayout, newAttendeeGridPros);
    
 // ready 이벤트 바인딩
    AUIGrid.bind(newAttendeeGridID, "ready", function(event) {
        newGridDataLength = AUIGrid.getGridData(newAttendeeGridID).length; // 그리드 전체 행수 보관
    });
    
    // 헤더 클릭 핸들러 바인딩
    AUIGrid.bind(newAttendeeGridID, "headerClick", newHeaderClickHandler);
    
    // 셀 수정 완료 이벤트 바인딩
    AUIGrid.bind(newAttendeeGridID, "cellEditEnd", function(event) {
        
        // isActive 칼럼 수정 완료 한 경우
        if(event.dataField == "isActive") {
            
            // 그리드 데이터에서 isActive 필드의 값이 Active 인 행 아이템 모두 반환
            var activeItems = AUIGrid.getItemsByValue(newAttendeeGridID, "isActive", "Active");
            
            // 헤더 체크 박스 전체 체크 일치시킴.
            if(activeItems.length != newGridDataLength) {
                document.getElementById("newAllCheckbox").checked = false;
            } else if(activeItems.length == gridDataLength) {
                 document.getElementById("newAllCheckbox").checked = true;
            }
        }
    });
    
    // course type
    CommonCombo.make("newCodeId", "/organization/training/selectCourseTypeList.do", null, "${courseInfo.codeId}", {
        id: "codeId",
        name: "codeName",
        type:"S"
    });
    
    // Memeber (Y/N)
    CommonCombo.make("generalCodeView", "/common/selectCodeList.do", {groupCode : '328'}, "${courseInfo.coursMemYnId}", {
        id: "codeId",
        name: "code",
        isShowChoose: false,
        type:"S"
    });
    
    // Member Type
    CommonCombo.make("memTypeView", "/common/selectCodeList.do", {groupCode : '1'}, "${courseInfo.coursMemTypeId}", {
        id: "codeId",
        name: "code",
        type:"S"
    });
    
    // Attendance
    CommonCombo.make("attendanceView", "/common/selectCodeList.do", {groupCode : '327'}, "${courseInfo.coursAttendOwner}", {
        id: "codeId",
        name: "code",
        isShowChoose: false,
        type:"S"
    });
    
    function fn_checkMemberTypeView(){
    	var val = $("#generalCodeView").val();
        if(val == "2318") {
            $("#memTypeView").removeAttr("disabled");
        } else {
            $("#memTypeView").attr("disabled", "disabled");
        }
    }
    
    function fn_checkAttendanceView(){
    	var val = $("#attendanceView").val();
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
    
    $("#newAttendee_btn").click(function() {
    	fn_attendeePop("new");
    });
    $("#newAddRow_btn").click(function() {
    	fn_addRow(newAttendeeGridID);
    });
    $("#newDelRow_btn").click(function() {
    	fn_delRow(newAttendeeGridID);
    });
    $("#new_save_btn").click(fn_updateCourseAttendee);
    
    AUIGrid.setGridData(newAttendeeGridID, $.parseJSON('${attendeeList}'));
});

//그리드 헤더 클릭 핸들러
function newHeaderClickHandler(event) {
    
    // isActive 칼럼 클릭 한 경우
    if(event.dataField == "isActive") {
        if(event.orgEvent.target.id == "newAllCheckbox") { // 정확히 체크박스 클릭 한 경우만 적용 시킴.
            var  isChecked = document.getElementById("newAllCheckbox").checked;
            newCheckAll(isChecked);
        }
        return false;
    }
}

// 전체 체크 설정, 전체 체크 해제 하기
function newCheckAll(isChecked) {
    
     var idx = AUIGrid.getRowCount(newAttendeeGridID); 
    
    // 그리드의 전체 데이터를 대상으로 isActive 필드를 "Active" 또는 "Inactive" 로 바꿈.
    if(isChecked) {
        for(var i = 0; i < idx; i++){
            //AUIGrid.updateAllToValue(invoAprveGridID, "isActive", "Active");
            AUIGrid.setCellValue(newAttendeeGridID, i, "isActive", "Active")
        }
    } else {
        AUIGrid.updateAllToValue(newAttendeeGridID, "isActive", "Inactive");
    }
    
    // 헤더 체크 박스 일치시킴.
    document.getElementById("newAllCheckbox").checked = isChecked;
}

function fn_updateCourseAttendee() {
	var obj = $("#form_newCours").serializeJSON();
	obj.gridData = GridCommon.getEditData(newAttendeeGridID);
	console.log(obj);
	Common.ajax("POST", "/organization/training/updateCourseAttendee.do", obj, function(result) {
        console.log(result);
        
        $("#courseViewPop").remove();
        
        Common.alert('Saved successfully.');
        
        fn_selectCourseList();
    });
}

var prev = "";
var regexp = /^\d*(\.\d{0,2})?$/;

function fn_inputAmt(obj){
    
    if(obj.value.search(regexp) == -1){
        obj.value = prev;
    }else{
        prev = obj.value;
    }
    
}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>View/Edit Course</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h2>Course Registration</h2>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form_newCours">
<input type="hidden" id="newCoursId" name="coursId" value="${courseInfo.coursId}">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:120px" />
	<col style="width:*" />
	<col style="width:150px" />
	<col style="width:*" />
	<col style="width:200px" />
	<col style="width:250px" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Course Type<span class="must">*</span></th>
	<td>
	<select class="w100p" id="newCodeId" name="codeId">
	</select>
	</td>
	<th scope="row">Member(Y/N)/Type<span class="must">*</span></th>
	<td>
	<select class="wAuto" id="generalCodeView" name="generalCode" onchange="javascript:fn_checkMemberTypeView()">
	</select>
	<select class="wAuto ml5" id="memTypeView" name="memType">
	</select>
	</td>
	<th scope="row">Training Period<span class="must">*</span></th>
	<td>
		<div class="date_set w100p"><!-- date_set start -->
		<p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="newCoursStart" name="coursStart" value="${courseInfo.coursStart}"/></p>
		<span>To</span>
		<p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="newCoursEnd" name="coursEnd" value="${courseInfo.coursEnd}"/></p>
		</div><!-- date_set end -->
	</td>
</tr>
<tr>
	<th scope="row">Course Name<span class="must">*</span></th>
	<td colspan="3"><input type="text" title="" placeholder="" class="w100p" id="coursName" name="coursName" value="${courseInfo.coursName}"/></td>
	<th scope="row">Course Code<span class="must">*</span></th>
	<td><input type="text" title="" placeholder="" class="readonly w100p" readonly="readonly" id="coursCode" name="coursCode" value="${courseInfo.coursCode}"/></td>
</tr>
<tr>
	<th scope="row">Location<span class="must">*</span></th>
	<td colspan="3"><input type="text" title="" placeholder="" class="w100p" id="coursLoc" name="coursLoc" value="${courseInfo.coursLoc}"/></td>
	<th scope="row">Attendance / Course Limit <span class="must">*</span></th>
	<td>
		<div class="text_select">
			<select id="attendanceView" name="attendance" onchange="javascript:fn_checkAttendanceView()">
			</select>
			<input type="text" title="" placeholder="" id="coursLimit" name="coursLimit" value="${courseInfo.coursLimit}" onkeyup="fn_inputAmt(this)"/>
		</div>
	</td>
</tr>
</tbody>
</table>

</form>
</section><!-- search_table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Attendee List</h2>
<ul class="right_btns">
	<li><p class="btn_grid"><a href="#" id="newAttendee_btn">Attendee</a></p></li>
	<li><p class="btn_grid"><a href="#" id="newAddRow_btn">Add</a></p></li>
	<li><p class="btn_grid"><a href="#" id="newDelRow_btn">Del</a></p></li>
</ul>
</aside><!-- title_line end -->

<article class="grid_wrap" id="newAttendee_grid_wrap"><!-- grid_wrap start -->
</article><!-- grid_wrap end -->

<ul class="center_btns">
	<li><p class="btn_blue2 big"><a href="#" id="new_save_btn">Save</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->