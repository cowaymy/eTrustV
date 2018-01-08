<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<script type="text/javaScript">
/********************************Global Variable Start***********************************/
// 행 추가, 삽입
var cnt = 0;
var selectedRow = -1;
var popSelectedRow = -1;
var grdUser = "";
var gridDataLength=0;
var gridDetailDataLength=0;
var popDivCd = "";
/********************************Global Variable End************************************/
/********************************Function  Start***************************************/
//그리드 헤더 클릭 핸들러
function headerClickHandler(event) {

    // isActive 칼럼 클릭 한 경우
    if(event.dataField == "funcYn") {
        if(event.orgEvent.target.id == "allCheckbox") { // 정확히 체크박스 클릭 한 경우만 적용 시킴.
            var  isChecked = document.getElementById("allCheckbox").checked;
            checkAll(isChecked);
        }
        return false;
    }
};

// 전체 체크 설정, 전체 체크 해제 하기
function checkAll(isChecked) {

    // 그리드의 전체 데이터를 대상으로 isActive 필드를 "Active" 또는 "Inactive" 로 바꿈.
    if(isChecked) {
        var item = { funcYn : "Y" };
        for(idx = 0 ; idx < gridDetailDataLength ; idx++){
        	if(AUIGrid.getItemByRowIndex(grdMenuMapping,idx).existYn == "N"){
        	    AUIGrid.updateRow(grdMenuMapping, item, idx);
        	}
        }
    } else {
    	var item = { funcYn : "N" };
    	for(idx = 0 ; idx < gridDetailDataLength ; idx++){
    		if(AUIGrid.getItemByRowIndex(grdMenuMapping,idx).existYn == "N"){
    			AUIGrid.updateRow(grdMenuMapping, item, idx);
    		}
        }
    }

    // 헤더 체크 박스 일치시킴.
    document.getElementById("allCheckbox").checked = isChecked;
};

//특정 칼럼 값으로 체크하기 (기존 더하기)
function addCheckedRowsByValue() {

    // rowIdField 와 상관없이 행 아이템의 특정 값에 체크함
    // 행아이템의 name 필드 중 Emma 라는 사람을 모두 체크함
    AUIGrid.addCheckedRowsByValue(grdMenuMapping, "funcYn", "N");

    // 만약 복수 값(Emma, Steve) 체크 하고자 한다면 다음과 같이 배열로 삽입
    //AUIGrid.addCheckedRowsByValue(myGridID, "name", ["Emma", "Steve"]);
};

//특정 칼럼 값으로 체크 해제 하기
function addUncheckedRowsByValue() {
    // 행아이템의 name 필드 중 Emma 라는 사람을 모두 체크 해제함
    AUIGrid.addUncheckedRowsByValue(grdMenuMapping, "name", "Emma");
};

//필드값으로 아이템들 얻기
function getItemsByField() {
    // 그리드 데이터에서 isActive 필드의 값이 Active 인 행 아이템 모두 반환
    var activeItems = AUIGrid.getItemsByValue(grdUser, "funcYn", "Y");
};

function fn_checkChangeRows(gridId,mandatoryItems){
    var addList = AUIGrid.getAddedRowItems(gridId);
    // 수정된 행 아이템들(배열)
    //var updateList = AUIGrid.getEditedRowColumnItems(gridId);
    var updateList = AUIGrid.getEditedRowItems(gridId);
    // 삭제된 행 아이템들(배열)
    var removeList = AUIGrid.getRemovedItems(gridId);

    var totalLength = 0;
    totalLength = addList.length + updateList.length + removeList.length;

	if(totalLength == 0){
		Common.alert("<spring:message code='sys.common.alert.noChange'/>");
		return true; /* Failed */
	}

	return false; /* Success */
}

function fn_openPopup_New() {
     var popUpObj = Common.popupDiv
     (
          "/common/userManagement/userManagementNew.do"
          , ""
          , null
          , "false"
          , "userManagementNewPop"
     );

}

function fn_openPopup_Edit(_popDivCd) {
	 if(AUIGrid.getSelectedIndex(grdUser)[0] < 0 ){
		 Common.alert("<spring:message code='sys.info.grid.selectMessage'/>"+" Grid");
         return;
     }
	popDivCd = _popDivCd;
    var popUpObj = Common.popupDiv
    (
         "/common/userManagement/userManagementEdit.do"
         , ""
         , null
         , "false"
         , "userManagementEditPop"
    );

}
/****************************Function  End***********************************/
/****************************Transaction Start********************************/

function fn_search(){
	Common.ajax(
		    "GET",
		    "/common/userManagement/selectUserList.do",
		    $("#searchForm").serialize(),
		    function(data, textStatus, jqXHR){ // Success
		    	AUIGrid.setGridData(grdUser, data);
		    },
		    function(jqXHR, textStatus, errorThrown){ // Error
		    	alert("Fail : " + jqXHR.responseJSON.message);
		    }
	)
};


/****************************Transaction End**********************************/
/**************************** Grid setting Start ********************************/
var gridAuthColumnLayout =
[
     /* PK , rowid 용 칼럼*/
	 {
	     dataField : "rowId",
	     dataType : "string",
	     visible : false
	 },
    {
        dataField : "userId",
        /* dataType : "string", */
        headerText : "User Id",
        width : "10%"
    },
    {
        dataField : "userName",
        headerText : "User Name",
        width : "10%",
        style : "aui-grid-user-custom-left"
    },
    {
        dataField : "userFullName",
        dataType : "string",
        width : "10%",
        headerText : "Full Name",

    },
    {
        dataField : "roleId",
        dataType : "string",
        width : "7%",
        headerText : "RoleId"

    },
    {
        dataField : "roleCode",
        dataType : "string",
        width : "10%",
        headerText : "RoleNm"

    },
    {
        dataField : "userStusNm",
        dataType : "string",
        width : "10%",
        headerText : "Status"

    },
    {
        dataField : "userBrnchNm",
        dataType : "string",
        headerText : "Branch"
    },
    {
        dataField : "userDeptNm",
        dataType : "string",
        headerText : "Department"

    },
    {
        dataField : "userValIdFrom",
        headerText : "Valid From"

    },
    {
        dataField : "userValIdTo",
        headerText : "Valid To"

    },
    {
        dataField : "userIsPartTm",
        dataType : "string",
        headerText : "Part-Timer",
        renderer : {
            type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "1", // true, false 인 경우가 기본
            unCheckValue : "0"
        }
    },
    {
        dataField : "userIsExtrnl",
        dataType : "string",
        headerText : "External",

        renderer : {
            type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "1", // true, false 인 경우가 기본
            unCheckValue : "0"
        }

    }

];

//selectionMode (String) : 설정하고자 하는 selectionMode(유효값 : singleCell, singleRow, multipleCells, multipleRows, none)

var options =
{
		editable : false,
// 		pagingMode : "simple",
        usePaging : true, //페이징 사용
        useGroupingPanel : false, //그룹핑 숨김
        showRowNumColumn : false, // 순번 칼럼 숨김
        applyRestPercentWidth  : false,
        rowIdField : "rowId", // PK행 지정
        selectionMode : "singleRow",
        editBeginMode : "click", // 편집모드 클릭
        softRemovePolicy : "exceptNew" //사용자추가한 행은 바로 삭제

};

var gridMenuMappingColumnLayout =
[
     /* PK , rowid 용 칼럼*/
	 {
	     dataField : "rowId",
	     dataType : "string",
	     visible : false
	 },
	{
	    dataField : "menuLvl",
	    /* dataType : "string", */
	    headerText : "Lvl",
	    editable : false, // 추가된 행인 경우만 수정 할 수 있도록 editable : true 로 설정 (cellEditBegin 이벤트에서 제어함)
	    width : "8%"
	},
	{
	    dataField : "menuName",
	    headerText : "Menu Name",
	    width : "30%",
	    editable : false,
	    style : "aui-grid-user-custom-left"
	},
    {
        dataField : "pgmName",
        headerText : "Program Name",
        width : "30%",
        editable : false,
        style : "aui-grid-user-custom-left"
    },
    {
        dataField : "pgmTrnName",
        headerText : "Transaction",
        width : "20%",
        editable : false,
        style : "aui-grid-user-custom-left"
    },
    {
        dataField : "funcYn",
        headerText : "<input type='checkbox' id='allCheckbox' style='width:15px;height:15px;''>",
        editable : true,
        renderer : {
            type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "Y", // true, false 인 경우가 기본
            unCheckValue : "N",
            styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
                if(item.existYn == "Y") {
                    return "disable-check-style";
                }
                return null;
            },
            // 체크박스 disabled 함수
            disabledFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
                if(item.existYn == "Y")
                    return true; // true 반환하면 disabled 시킴
                return false;
            }
//          // 체크박스 Visible 함수
//          visibleFunction : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
//              if(item.charge == "Anna")
//                  return false; // 책임자가 Anna 인 경우 체크박스 표시 안함.
//              return true;
//          }
        }
    },
    {
        dataField : "ownerYn",
        headerText : "Owner Yn",
        editable : false,
        renderer : {
            type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "Y", // true, false 인 경우가 기본
            unCheckValue : "N"
        },
        visible : false
    },
    {
        dataField : "existYn",
        headerText : "Exist Yn",
        editable : false,
        renderer : {
            type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "Y", // true, false 인 경우가 기본
            unCheckValue : "N"
        },
        visible : false
    },
    {
        dataField : "baseYn",
        headerText : "Baseauth Yn",
        editable : false,
        renderer : {
            type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "Y", // true, false 인 경우가 기본
            unCheckValue : "N"
        },
        visible : false
    }

];

var detailOptions =
{
		editable : true,
        usePaging : true, //페이징 사용
        useGroupingPanel : false, //그룹핑 숨김
        showRowNumColumn : false, // 순번 칼럼 숨김
        applyRestPercentWidth  : false,
        rowIdField : "rowId", // PK행 지정
        selectionMode : "multipleRows",
        editBeginMode : "click", // 편집모드 클릭
        /* aui 그리드 체크박스 옵션*/
        softRemovePolicy : "exceptNew" //사용자추가한 행은 바로 삭제

};


/****************************Program Init Start********************************/
$(document).ready(function(){
    // AUIGrid 그리드를 생성
    grdUser = GridCommon.createAUIGrid("grdUser", gridAuthColumnLayout,"", options);
    // ready 이벤트 바인딩
    AUIGrid.bind(grdUser, "ready", function(event) {
        gridDataLength = AUIGrid.getGridData(grdUser).length; // 그리드 전체 행수 보관
    });

    // click 이벤트 바인딩
    AUIGrid.bind(grdUser, ["cellClick"], function(event) {
    	selectedRow = event.rowIndex;
//     	fn_detailSearch(event.item.authCode);
    });
/*
//     grdMenuMapping = GridCommon.createAUIGrid("grdMenuMapping", gridMenuMappingColumnLayout,"", detailOptions);

//     AUIGrid.bind(grdMenuMapping, ["cellClick"], function(event) {

//     });

//     AUIGrid.bind(grdMenuMapping, "ready", function(event) {
//     	gridDetailDataLength = AUIGrid.getGridData(grdMenuMapping).length; // 그리드 전체 행수 보관

//     	for(var idx = 0 ; idx < gridDetailDataLength ; idx++){

//     	}
//     });

    // 헤더 클릭 핸들러 바인딩(checkAll)
    AUIGrid.bind(grdMenuMapping, "headerClick", headerClickHandler);

    // 셀 수정 완료 이벤트 바인딩 (checkAll)
    AUIGrid.bind(grdMenuMapping, "cellEditEnd", function(event) {
        // isActive 칼럼 수정 완료 한 경우
        if(event.dataField == "funcYn") {
            // 그리드 데이터에서 isActive 필드의 값이 Active 인 행 아이템 모두 반환
            var activeItems = AUIGrid.getItemsByValue(grdMenuMapping, "funcYn", "Y");
            // 헤더 체크 박스 전체 체크 일치시킴.
            if(activeItems.length != gridDetailDataLength) {
                document.getElementById("allCheckbox").checked = false;
            } else if(activeItems.length == gridDataLength) {
                 document.getElementById("allCheckbox").checked = true;
            }
        }
    });

*/
    AUIGrid.clearGridData(grdUser);
//     AUIGrid.clearGridData(grdMenuMapping);
});
/****************************Program Init End********************************/
</script>

<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
.aui-grid-user-custom-right {
    text-align:right;
}

/* 엑스트라 체크박스 사용자 선택 못하는 표시 스타일 */
.disable-check-style {
    color:#d3825c;
}

</style>

<section id="content"><!-- content start -->
<ul class="path">
</ul>
<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>User Management</h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a onclick="fn_search()"><span class="search"></span>Search</a></p></li>
    </c:if>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="searchForm" action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:100px" />
    <col style="width:*" />
    <col style="width:100px" />
    <col style="width:*" />
    <col style="width:100px" />
    <col style="width:*" />
    <col style="width:100px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">User Name</th>
    <td><input id="userName" type="text" name="userName" title="" placeholder="User Name" class="w100p" /></td>
    <th scope="row">Full Name</th>
    <td><input id="userFullName" type="text" name="userFullName" title="" placeholder="User Full Name" class="w100p" /></td>
    <th scope="row">Contact<br>(Mobile)</th>
    <td><input id="userMobileNo" type="text" name="userMobileNo" title="" placeholder="Contact (Mobile Number)" class="w100p" /></td>
    <th scope="row">Contact<br>(Work)</th>
    <td><input id="userWorkNo" type="text" name="userWorkNo" title="" placeholder="Contact (Work Number)" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Status</th>
    <td>
    <select id="userStusId" name="userStusId" class="w100p" >
        <option value="">- All -</option>
        <option value="1">Active</option>
        <option value="8">Inactive</option>
    </select>
    </td>
    <th scope="row">Extension No</th>
    <td><input id="userExtNo" type="text" name="userExtNo" title="" placeholder="Extension No" class="w100p" /></td>
    <th scope="row">Join Date</th>
    <td><input id="userDtJoinM" type="text" name="userDtJoinM" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>
    <th scope="row">Email</th>
    <td><input id="userEmail" type="text" name="userEmail" title="" placeholder="Email" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">NRIC</th>
    <td><input  id="userNric" type="text" name="userNric" title="" placeholder="NRIC" class="w100p" /></td>
    <th scope="row">Role</th>
    <td><input  id="roleId" type="text" name="roleId" title="" placeholder="Role ID or Name" class="w100p" /></td>
    <th scope="row">Div</th>
    <td colspan="3">
    <label><input id="userIsPartTm" type="checkbox" name="userExtType" value=""/><span>Part-Timer</span></label>
    <label><input id="userIsExtrnl" type="checkbox" name="userExtType" value="" /><span>External User</span></label>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->


<!-- <div class="divine_auto"> --><!-- divine_auto start -->

<!-- <div class="border_box" style="width:35%;"> --><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">User List</h3>
<ul class="right_opt">
    <!--
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    </c:if>
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    </c:if>
    <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine5 == 'Y'}">
    </c:if>
    -->

    <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_grid"><a onclick="fn_openPopup_Edit('branch')">Edit Branch</a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_grid"><a onclick="fn_openPopup_Edit()">Edit</a></p></li>
    <li><p class="btn_grid"><a onclick="fn_openPopup_New()">New</a></p></li>
    </c:if>
</ul>
</aside><!-- title_line end -->
<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grdUser" style="height:385px"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->
<!-- </div> --><!-- border_box end -->
<!-- <div style="width:65%;">
<aside class="title_line">title_line start
<h3 class="pt0">User Detail</h3>
</aside>title_line end

<table class="type1" style="height:260px">table start
<caption>table</caption>
<colgroup>
    <col style="width:110px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row" >User Type<span class="must">*</span></th>
    <td >
    <select  class="w100p">
        <option value="">- Choose -</option>
    </select>
    </td>
    <td colspan="2">
    <label><input type="checkbox" /><span>Part-Timer</span></label>
    <label><input type="checkbox" /><span>External User</span></label>
    </td>
</tr>
<tr>
    <th scope="row">User Name<span class="must">*</span></th>
    <td>
    <input type="text" title="" placeholder="User Name" class="w100p" />
    </td>
    <th scope="row">Full Name<span class="must">*</span></th>
    <td>
    <input type="text" title="" placeholder="Full Name" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Password<span class="must">*</span></th>
    <td>
    <input type="password" title="" placeholder="" class="w100p" />
    </td>
    <th scope="row">Re-Key Password<span class="must">*</span></th>
    <td>
    <input type="password" title="" placeholder="" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Branch<span class="must">*</span></th>
    <td>
    <select class="w100p">
        <option value="">- Choose -</option>
    </select>
    </td>
    <th scope="row">Department<span class="must">*</span></th>
    <td>
    <select class="w100p">
        <option value="">- Choose -</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Valid Date<span class="must">*</span></th>
    <td>

    <div class="date_set w100p">date_set start
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" /></p>
    </div>date_set end

    </td>
    <th scope="row">Department<br>(CallCenter_Use)</th>
    <td>
    <select class="w100p">
        <option value="">- Choose -</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Email<span id="emailSpan" class="must">*</span></th>
    <td>
    <input type="text" title="" placeholder="Email (Coway Email Only)" class="w100p" />
    </td>
    <th scope="row">Join Date</th>
    <td>
    <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" />
    </td>
</tr>
<tr>
    <th scope="row">NRIC</th>
    <td>
    <input type="text" title="" placeholder="NRIC" class="w100p" />
    </td>
    <th scope="row">Extension No</th>
    <td>
    <input type="text" title="" placeholder="Extension No" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Contact (Work)</th>
    <td>
    <input type="text" title="" placeholder="Contact (Work)" class="w100p" />
    </td>
    <th scope="row">Contact (Mobile)</th>
    <td>
    <input type="text" title="" placeholder="Contact (Mobile)" class="w100p" />
    </td>
</tr>
<tr>
    <td colspan="4" class="col_all">
    <span>* Compulsory Field ** Compulsory Field (Except part-timer & external user)</span>
    </td>
</tr>
</tbody>
</table>table end

<aside class="title_line" style="margin-top:13px;">title_line start
<h3>User Role Information</h3>
</aside>title_line end

<table class="type1" style="height:80px">table start
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Role (Lvl 1)<span class="must">*</span></th>
    <td>
    <select class="w100p">
        <option value="">- Choose -</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Role (Lvl 2)<span class="must">*</span></th>
    <td>
    <select class="w100p">
        <option value="">- Choose -</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Role (Lvl 3)<span class="must">*</span></th>
    <td>
    <select class="w100p">
        <option value="">- Choose -</option>
    </select>
    </td>
</tr>
</tbody>
</table>table end

</div> -->
<!-- </div> --><!-- divine_auto end -->
</section><!-- content end -->