<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
/********************************Global Variable Start***********************************/
// 행 추가, 삽입
var cnt = 0;
var selectedRow = -1;
var popSelectedRow = -1;
var grdAuth = "";
var grdMenuMapping = "";
var gridDataLength=0;
var gridDetailDataLength=0;
var gSelMainRowIdx = 0;
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
//         AUIGrid.updateAllToValue(grdMenuMapping, "funcYn", "Y");
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
//         AUIGrid.updateAllToValue(grdMenuMapping, "funcYn", "N");
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
    var activeItems = AUIGrid.getItemsByValue(grdAuth, "funcYn", "Y");
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
/****************************Function  End***********************************/
/****************************Transaction Start********************************/

function fn_search(){

    $("#authCode").val("");

    Common.ajax(
            "GET",
            "/common/selectAuthList.do",
            $("#searchForm").serialize(),
            function(data, textStatus, jqXHR){ // Success
                AUIGrid.clearGridData(grdMenuMapping);
                AUIGrid.setGridData(grdAuth, data);
            },
            function(jqXHR, textStatus, errorThrown){ // Error
                alert("Fail : " + jqXHR.responseJSON.message);
            }
    )
};

function fn_clear(){
    $("#searchForm")[0].reset();
}

function fn_detailSearch(authCode){

    var authCode = "";

    if(AUIGrid.getSelectedItems(grdAuth).length > 0){
        authCode = AUIGrid.getSelectedItems(grdAuth)[0].item.authCode;
        $("#authCode").val(authCode);
    }else{
        Common.alert("<spring:message code='sys.info.grid.selectMessage'/>"+" Auth Grid");
        return;
    }

    Common.ajax(
            "GET",
            "/mobileAuthMenu/selectMobileRoleAuthMappingAdjustList.do",
            "authCode="+authCode,
            function(data, textStatus, jqXHR){ // Success
//              alert(JSON.stringify(data));
                AUIGrid.setGridData(grdMenuMapping, data);
            },
            function(jqXHR, textStatus, errorThrown){ // Error
                alert("Fail : " + jqXHR.responseJSON.message);
            }
    )

   /*  Common.ajax("GET", "/mobileAuthMenu/selectMobileRoleAuthMappingAdjustList.do"
            , $("#MainForm").serialize()
            , function(result)
            {
               console.log("성공 data : " + result);
               AUIGrid.setGridData(AuthGridID, result);
               if(result != null && result.length > 0)
               {
               }
            }); */
};

function fn_detailSearchForMenu(){
    var authCode = "";

/*     if(AUIGrid.getSelectedItems(grdAuth).length > 0){
        authCode = AUIGrid.getSelectedItems(grdAuth)[0].item.authCode;
    }else{
        Common.alert("<spring:message code='sys.info.grid.selectMessage'/>"+" Auth Grid");
        return;
    }

    Common.ajax(
            "GET",
            "/common/selectAuthMenuMappingList.do",
            "authCode="+authCode+"&menuCode="+$("#menuCode").val(),
            function(data, textStatus, jqXHR){ // Success
//              alert(JSON.stringify(data));
                AUIGrid.setGridData(grdMenuMapping, data);
            },
            function(jqXHR, textStatus, errorThrown){ // Error
                alert("Fail : " + jqXHR.responseJSON.message);
            }
    ) */
};

function fn_detailSave(){
    if(fn_checkChangeRows(grdMenuMapping)){
        return;
    }
    Common.confirm("<spring:message code='sys.common.alert.save'/>",function(){
        Common.ajax(
                "POST",
                "/common/saveAuthMenuMappingList.do",
                GridCommon.getEditData(grdMenuMapping),
                function(data, textStatus, jqXHR){ // Success
                    Common.alert("<spring:message code='sys.msg.success'/>");
                    fn_search();
                },
                function(jqXHR, textStatus, errorThrown){ // Error
                    alert("Fail : " + jqXHR.responseJSON.message);
                }
        )
    });
};

//행 추가, 삽입
function fnAddRow()
{
  if( $("#authCode").val().length == 0 )
  {
      Common.alert("<spring:message code='sys.msg.first.Select' arguments='Auth Code' htmlEscape='false'/>");
      return false;
  }

  var item = new Object();

      item.authCode = $("#authCode").val();
      item.hidden   ="";  // old_auth_code
      item.rowId   ="PkAddNew";

      // parameter
      // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
      // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
      AUIGrid.addRow(grdMenuMapping, item, "first");
}

// 전체메뉴추가
function fnALLAddRow()
{
    if( $("#authCode").val().length == 0 )
	{
    	   Common.alert("<spring:message code='sys.msg.first.Select' arguments='Auth Code' htmlEscape='false'/>");
    	   return false;
	}

    if( AUIGrid.getRowCount(grdMenuMapping) > 0 ){
    	return false;
    }

    if(AUIGrid.getSelectedItems(grdAuth).length > 0){
        authCode = AUIGrid.getSelectedItems(grdAuth)[0].item.authCode;
        $("#authCode").val(authCode);
    }

    Common.ajax(
            "GET",
            "/mobileAuthMenu/selectMobileMenuAuthMenuList.do",
            "",
            function(data, textStatus, jqXHR){ // Success
//              alert(JSON.stringify(data));
                //AUIGrid.setGridData(grdMenuMapping, data);

                // 추가시킬 행 10개 작성
                var item;
                var rowList = [];

                for(var i=0; i<data.length; i++) {
                    rowList[i] = {
                       	menuLvl     : data[i].menuLvl,
                        menuCode  : data[i].menuCode,
                        menuName : data[i].menuName,
                        pgmCode   : data[i].pgmCode,
                        pgmName  : data[i].pgmName,
                        authCode  : $("#authCode").val(),
                        rowId       : "PkAddNew"

                    }
                }

                // parameter
                // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
                // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
                AUIGrid.addRow(grdMenuMapping, rowList, "first");

            },
            function(jqXHR, textStatus, errorThrown){ // Error
                alert("Fail : " + jqXHR.responseJSON.message);
            }
    )

    /*
    var data = {};
    data.authCode = authCode;
    Common.ajax("POST", "/mobileAuthMenu/saveMobileMenuAuthAllRoleMapping.do", data, function(result) {
    	fn_detailSearch();
    });
    */



}

function fnAuthGridIDRemoveRow()
{
  console.log("fnAuthGridIDRemoveRow: " + gSelMainRowIdx);
  AUIGrid.removeRow(grdMenuMapping,"selectedIndex");
}

function fnSaveMobileMenuAuthCd()
{
  if (fnValidationCheck() == false)
  {
    return false;
  }

  Common.ajax("POST", "/mobileAuthMenu/saveMobileMenuAuthRoleMapping.do"
        , GridCommon.getEditData(grdMenuMapping)
        , function(result)
          {
            Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");

            //fnCellClickSelectRoleAuthListAjax();
            fn_detailSearch();
            validFrom = "";
            validTo = "";
            console.log("성공." + JSON.stringify(result));
            console.log("data : " + result.data);
          }
        , function(jqXHR, textStatus, errorThrown)
          {
            try
            {
              console.log("Fail Status : " + jqXHR.status);
              console.log("code : "        + jqXHR.responseJSON.code);
              console.log("message : "     + jqXHR.responseJSON.message);
              console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
            }
            catch (e)
            {
              console.log(e);
            }

            Common.alert("Fail : " + jqXHR.responseJSON.message);

          });
  }

function fnValidationCheck()
{
    var result = true;
    var addList = AUIGrid.getAddedRowItems(grdMenuMapping);
    var udtList = AUIGrid.getEditedRowItems(grdMenuMapping);
    var delList = AUIGrid.getRemovedItems(grdMenuMapping);

    if (addList.length == 0  && udtList.length == 0 && delList.length == 0)
    {
      Common.alert("No Change");
      return false;
    }

    for (var i = 0; i < addList.length; i++)
    {
      var authCode  = addList[i].authCode;
      var menuCode  = addList[i].menuCode;

      if (FormUtil.isEmpty(authCode))
      {
        result = false;
        // {0} is required.
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Auth Code' htmlEscape='false'/>");
        break;
      }

      if (FormUtil.isEmpty(menuCode))
      {
        result = false;
        // {0} is required.
        Common.alert("<spring:message code='sys.msg.necessary' arguments='Menu' htmlEscape='false'/>");
        break;
      }

    }  // addlist

    for (var i = 0; i < delList.length; i++)
    {
        var menuCode  = delList[i].menuCode;

        if (FormUtil.isEmpty(menuCode))
        {
          result = false;
          // {0} is required.
          Common.alert("<spring:message code='sys.msg.necessary' arguments='Menu' htmlEscape='false'/>");
          break;
        }

     } //delete

    return result;
  }

function fnSearchMenuPopUp()
{
   var popUpObj = Common.popupDiv("/mobileAuthMenu/searchMobileAuthMenuPop.do"
       , $("#MainForm").serializeJSON()
       , null
       , true  // true면 더블클릭시 close
       , "searchMenuPop"
       );
}

function auiCellEditignHandler(event)
{
    if(event.type == "cellEditBegin")
    {
        console.log("에디팅 시작(cellEditBegin) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
        //var menuSeq = AUIGrid.getCellValue(myGridID, event.rowIndex, 11);

        if(event.dataField == "menuCode")
        {
            // 추가된 행 아이템인지 조사하여 추가된 행인 경우만 에디팅 진입 허용
           if(AUIGrid.isAddedById(myGridID, event.item.rowId) == false && (event.item.rowId =="PkAddNew") )  //추가된 Row
           {
                return true; // 수정가능
           }
           else
           {
              return false; // false 반환하면 기본 행위 안함(즉, cellEditBegin 의 기본행위는 에디팅 진입임)
           }
        }
        else
        {
             return true; // 다른 필드들은 편집 허용
        }

    }
    else if(event.type == "cellEditEnd")
    {
        console.log("에디팅 종료(cellEditEnd) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
    }
    else if(event.type == "cellEditCancel")
    {
        console.log("에디팅 취소(cellEditCancel) : ( " + event.rowIndex + ", " + event.columnIndex + " ) " + event.headerText + ", value : " + event.value);
    }

}

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
    /*
    {
        dataField : "chkAll",
        headerText : "<input type='checkbox' id='allCheckbox' style='width:15px;height:15px;''>",
        width:"8%",
        renderer : {
            type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "Y", // true, false 인 경우가 기본
            unCheckValue : "N"
        }
    },
    */
    {
        dataField : "authCode",
        /* dataType : "string", */
        headerText : "Auth Code",
        width : "30%",
    },
    {
        dataField : "authName",
        headerText : "Auth Name",
        style : "aui-grid-user-custom-left"
    }
];

//selectionMode (String) : 설정하고자 하는 selectionMode(유효값 : singleCell, singleRow, multipleCells, multipleRows, none)

var options =
{
        editable : false,
        pagingMode : "simple",
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
     {
         dataField : "menuLvl",
         headerText : "<spring:message code='sys.menumanagement.grid1.Lvl' />",
         width : "4%",
         editable : false,
     }, {
         dataField : "menuCode",
         headerText : "<spring:message code='sys.menumanagement.grid1.MenuId'/>",
         width : "13%",
         editable : false,
         style : "aui-grid-left-column",
         renderer :
         {
             type : "IconRenderer",
             iconWidth : 24, // icon 가로 사이즈, 지정하지 않으면 24로 기본값 적용됨
             iconHeight : 24,
             iconPosition : "aisleRight",
             iconFunction : function(rowIndex, columnIndex, value, item)
             {
                 switch(item.rowId )
                 {
                   case "PkAddNew":
                	   return "${pageContext.request.contextPath}/resources/images/common/normal_search.png";
                   default:
                	   return  null; // null 반환하면 아이콘 표시 안함.
                 }
             } ,// end of iconFunction

             onclick : function(rowIndex, columnIndex, value, item)
             {
                   console.log("onclick: ( " + rowIndex + ", " + columnIndex + " ) " + item.menuLvl + " POPUP 클릭");
                   gSelMainRowIdx = rowIndex;
                   fnSearchMenuPopUp();
              }
         } // IconRenderer
     }, {
         dataField : "menuName",
         headerText : "<spring:message code='sys.menumanagement.grid1.MenuNm' />",
         editable : false, // 추가된 행인 경우만 수정 할 수 있도록 editable : true 로 설정 (cellEditBegin 이벤트에서 제어함)
         style : "aui-grid-left-column",
         width : "22%"
     }, {
         dataField : "pgmCode",
         headerText : "<spring:message code='sys.menumanagement.grid1.ProgramId'/>",
         editable : false, // 추가된 행인 경우만 수정 할 수 있도록 editable : true 로 설정 (cellEditBegin 이벤트에서 제어함)
         width : "10%"
     }, {
         dataField : "pgmName",
         headerText : "<spring:message code='sys.menumanagement.grid1.ProgramNm' />",
         editable : false, // 추가된 행인 경우만 수정 할 수 있도록 editable : true 로 설정 (cellEditBegin 이벤트에서 제어함)
         style : "aui-grid-left-column",
         width : "*%"
     }, {
         // PK , rowid 용 칼럼
         dataField : "rowId",
         dataType : "string",
         visible : false
     }, {
         dataField : "authCode",
         dataType : "string",
         visible : false
     }

];

var detailOptions =
{
        //rowIdField : "rowId", // PK행 지정
        usePaging : false,
        showRowNumColumn : false, // 순번 칼럼 숨김
        useGroupingPanel : false,
        selectionMode : "multipleRows",
        // 셀머지된 경우, 행 선택자(selectionMode : singleRow, multipleRows) 로 지정했을 때 병합 셀도 행 선택자에 의해 선택되도록 할지 여부
        rowSelectionWithMerge : true,
        editable : true,
        // 셀, 행 수정 후 원본으로 복구 시키는 기능 사용 가능 여부 (기본값:true)
        enableRestore : true,
        //editBeginMode : "click", // 편집모드 클릭
        softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
         // row Styling 함수
        rowStyleFunction : function(rowIndex, item)
        {
          return "";
        }

};


/****************************Program Init Start********************************/
$(document).ready(function(){


    // AUIGrid 그리드를 생성
    grdAuth = GridCommon.createAUIGrid("grdAuth", gridAuthColumnLayout,"", options);
    // ready 이벤트 바인딩
    AUIGrid.bind(grdAuth, "ready", function(event) {
        gridDataLength = AUIGrid.getGridData(grdAuth).length; // 그리드 전체 행수 보관
    });

    // click 이벤트 바인딩
    AUIGrid.bind(grdAuth, ["cellClick"], function(event) {
        selectedRow = event.rowIndex;
        fn_detailSearch(event.item.authCode);
    });
/***************************************************[ Auth GRID] ***************************************************/
    grdMenuMapping = GridCommon.createAUIGrid("grdMenuMapping", gridMenuMappingColumnLayout,"", detailOptions);

    // cellClick event.
    AUIGrid.bind(grdMenuMapping, "cellClick", function( event )
    {
        gSelMainRowIdx = event.rowIndex;

        console.log("CellClick AuthGrid : " + event.rowIndex + ", columnIndex : " + event.columnIndex  );

    });

    AUIGrid.bind(grdMenuMapping, "ready", function(event) {
        gridDetailDataLength = AUIGrid.getGridData(grdMenuMapping).length; // 그리드 전체 행수 보관

    });

    // 헤더 클릭 핸들러 바인딩(checkAll)
    AUIGrid.bind(grdMenuMapping, "headerClick", headerClickHandler);

    // 에디팅 시작 이벤트 바인딩
    AUIGrid.bind(grdMenuMapping, "cellEditBegin", auiCellEditignHandler);

    // 에디팅 정상 종료 이벤트 바인딩
    AUIGrid.bind(grdMenuMapping, "cellEditEnd", auiCellEditignHandler);

    // 에디팅 취소 이벤트 바인딩
    AUIGrid.bind(grdMenuMapping, "cellEditCancel", auiCellEditignHandler);

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


    AUIGrid.clearGridData(grdAuth);
    AUIGrid.clearGridData(grdMenuMapping);
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
<h2>Authorization Menu Mapping</h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <!-- <li><p class="btn_blue"><a  onclick="fn_detailSave()">Save</a></p></li> -->
    </c:if>
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a onclick="fn_search()"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a onclick="fn_clear();" ><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
    </c:if>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="MainForm" method="get" action="" onsubmit="return false;">
  <input type="hidden" id="CodeMasterId" name="CodeMasterId" value="313" />
  <input type="hidden" id="authCode" name="authCode" value="" />
 </form>
<form id="searchForm" action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Auth</th>
    <td>
    <input id="authCode" name="authCode" type="text" title="" value="" placeholder="Auth Code or Name" class="" />
    </td>
    <!-- <th scope="row">Menu</th>
    <td>
    <input id="menuCode" name="menuCode" type="text" title="" value="" placeholder="Menu Code or Name" class="" />
    <a href="#" class="search_btn" onclick="javascript:fn_detailSearchForMenu()"><img src="/resources/images/common/normal_search.gif" alt="search"></a>
    </td> -->
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<!--
<p class="show_btn"><a href="#"><img src="../images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a href="#">menu1</a></p></li>
        <li><p class="link_btn"><a href="#">menu2</a></p></li>
        <li><p class="link_btn"><a href="#">menu3</a></p></li>
        <li><p class="link_btn"><a href="#">menu4</a></p></li>
        <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn"><a href="#">menu6</a></p></li>
        <li><p class="link_btn"><a href="#">menu7</a></p></li>
        <li><p class="link_btn"><a href="#">menu8</a></p></li>
    </ul>
    <ul class="btns">
        <li><p class="link_btn type2"><a href="#">menu1</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu3</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu4</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu6</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu7</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu8</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="../images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
-->
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<div class="divine_auto"><!-- divine_auto start -->

<div class="border_box" style="width:40%; height:450px;"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">Auth</h3>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grdAuth" class="autoGridHeight"></div>
</article><!-- grid_wrap end -->

</div><!-- border_box end -->

<div class="border_box" style="width:60%;height:450px;"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">Menu</h3>
<ul class="right_opt">
  <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
  <li><p class="btn_grid"><a onclick="fnALLAddRow();">ALL ADD</a></p></li>
  <li><p class="btn_grid"><a onclick="fnAuthGridIDRemoveRow();">DEL</a></p></li>
  <li><p class="btn_grid"><a onclick="fnAddRow();">ADD</a></p></li>
  <li><p class="btn_grid"><a onclick="fnSaveMobileMenuAuthCd();">SAVE</a></p></li>
  </c:if>
</ul>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grdMenuMapping" class="autoGridHeight"></div>
</article><!-- grid_wrap end -->

</div><!-- border_box end -->

</div><!-- divine_auto end -->


</section><!-- search_result end -->

</section><!-- content end -->