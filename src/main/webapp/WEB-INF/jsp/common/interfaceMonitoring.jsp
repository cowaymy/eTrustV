<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
/********************************Global Variable Start***********************************/
// 행 추가, 삽입
var cnt = 0;
var selectedRow = -1;
var _popSelectedRow = -1;
var grdIf = "";
var gridDataLength=0;
/*공통팝업 조회ID*/
var _queryId = "";
var _callbackFunc = "popupCallback";
//var keyValueList = [{code:"0", value:"Department"}, {code:"1", value:"Branch"}];
var keyValueList = null;
/*
function resizeHandler(aryHeight) {
    $(window).resize(function() {
        var bHeight = $("body").height();

        $(".grid_wrap.autoHeight").each(function(i) {
            var sHeight = bHeight - aryHeight[i];
            if ( sHeight < 200 ) sHeight = 200;  // Height 최소값 지정.

            if (bHeight != 200) {
                $(this).height(sHeight);
            }
        });
    });
    $(window).resize();
};
*/

/********************************Global Variable End************************************/
/********************************Function  Start***************************************/
function addRow() {
    var item = new Object();
    // parameter
    // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
    // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
    AUIGrid.addRow(grdIf, item, "first");
};

// 행 삭제
function delRow() {
    var rowPos = "selectedIndex"; //'selectedIndex'은 선택행 또는 rowposition : ex) 5
    AUIGrid.removeRow(grdIf, "selectedIndex");
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
		alert("No Change Data.");
		return true; /* Failed */
	}

	return false; /* Success */
}


function popupCallback(result){
    AUIGrid.setCellValue(grdIf, _popSelectedRow, "authCode", result.id);
    AUIGrid.setCellValue(grdIf, _popSelectedRow, "authName", result.name);
}


function lpad(param, length, str) {
    param = param + ""
    return param.length >= length ? param : new Array(length - param.length + 1).join(str) + param;
}

/****************************Function  End***********************************/
/****************************Transaction Start********************************/

function fn_search(){

	var changeDate = "";
	var param = "";

    changeDate = $("#searchDate").val().replace("/","");
    changeDate = changeDate.substring(2,8) + changeDate.substring(0,2) ;

    param = "ifType="+$("#ifType").val()+"&tranStatusCd="+$("#tranStatusCd").val()+"&searchDate="+changeDate;

	Common.ajax(
		    "GET",
		    "/common/selectInterfaceMonitoringList.do",
		    param,
		    function(data, textStatus, jqXHR){ // Success
		    	//AUIGrid.clearGridData(grdIf);
		    	AUIGrid.setGridData(grdIf, data);
		    },
		    function(jqXHR, textStatus, errorThrown){ // Error
		    	alert("Fail : " + jqXHR.responseJSON.message);
		    }
	)
};


function fn_detailSave(){
	if(fn_checkChangeRows(grdIf)){
		return;
	}

    var addList = AUIGrid.getAddedRowItems(grdIf);
    if(addList.length > 0){
        for(var idx = 0 ; idx < addList.length ; idx++){
        	if(addList[idx].ifType == "" || typeof(addList[idx].ifType) == "undefined"){
                AUIGrid.selectRowsByRowId(grdIf, addList[idx].rowId);
                alert("IF TYPE is essential field.");
                return;
            }
        }
    }

    if(confirm("Do you want to save it?")){
        Common.ajax(
                "POST",
                "/common/saveInterfaceMonitoringList.do",
                GridCommon.getEditData(grdIf),
                function(data, textStatus, jqXHR){ // Success
                    alert("Saved.");
                    fn_search();
                },
                function(jqXHR, textStatus, errorThrown){ // Error
                    alert("Fail : " + jqXHR.responseJSON.message);
                }
        )
    }
};

function fn_commCodesearch(){
    Common.ajax(
            "GET",
            "/common/selectCommonCodeStatusList.do",
            $("#searchForm").serialize(),
            function(data, textStatus, jqXHR){ // Success
            	 for(var idx = 0 ; idx < data.length ; idx++){
            		 $("#tranStatusCd").append("<option value='"+data[idx].code+"'>"+data[idx].value+"</option>");
            	 }
            },
            function(jqXHR, textStatus, errorThrown){ // Error
                alert("Fail : " + jqXHR.responseJSON.message);
            }
    )
};

function fn_commItfTypeSearch(){
    Common.ajax(
            "GET",
            "/common/selectInterfaceTypeList.do",
            $("#searchForm").serialize(),
            function(data, textStatus, jqXHR){ // Success
                 for(var idx = 0 ; idx < data.length ; idx++){
                     $("#ifType").append("<option value='"+data[idx].ifType+"'>"+data[idx].ifTypeNm+"</option>");
                 }
            },
            function(jqXHR, textStatus, errorThrown){ // Error
                alert("Fail : " + jqXHR.responseJSON.message);
            }
    )
};
/****************************Transaction End**********************************/
/**************************** Grid setting Start ********************************/

var gridIfColumnLayout =
[
     /* PK , rowid 용 칼럼*/
	 {
	     dataField : "rowId",
	     dataType : "string",
	     visible : false
	 },
	 {
         dataField : "ifType",
         headerText : "IF Type",
         width:"10%"
     },
     {
         dataField : "ifTypeNm",
         headerText : "IF Type Name",
         style : "aui-grid-user-custom-left",
         width:"10%"
     },
     {
         dataField : "chkCol",
         headerText : "Check Col",
         width:"10%"
     },
	 {
        dataField : "sndCnt",
        headerText : "BIZ Cnt",
        dataType : "numeric",
        formatString : "#,##0",
        width : "12%",
        style : "aui-grid-user-custom-right"
	},
    {
       dataField : "rcvCnt",
       headerText : "ITF Cnt",
       dataType : "numeric",
       formatString : "#,##0",
       width : "12%",
       style : "aui-grid-user-custom-right"
   },
   {
      dataField : "sndChkVal",
      headerText : "BIZ Check Value",\
      dataType : "numeric",
      formatString : "#,##0",
      width : "18%",
      style : "aui-grid-user-custom-right"
    },
    {
        dataField : "rcvChkVal",
        headerText : "ITF Check Value",
        dataType : "numeric",
        formatString : "#,##0",
        width : "18%",
        style : "aui-grid-user-custom-right"
     }
];

var detailOptions =
{
		editable : false,
        usePaging : true, //페이징 사용
        useGroupingPanel : false, //그룹핑 숨김
        showRowNumColumn : false, // 순번 칼럼 숨김
        applyRestPercentWidth  : false,
        rowIdField : "rowId", // PK행 지정
        selectionMode : "singleRow",
        editBeginMode : "click", // 편집모드 클릭
        /* aui 그리드 체크박스 옵션*/
        softRemovePolicy : "exceptNew" //사용자추가한 행은 바로 삭제
};


/****************************Program Init Start********************************/
$(document).ready(function(){

    grdIf = GridCommon.createAUIGrid("grdIf", gridIfColumnLayout,"", detailOptions);
    AUIGrid.bind(grdIf, ["cellDoubleClick"], function(event) {
        if(event.item.ifType == "110" || event.item.ifType == "771"){
            var popUpObj = Common.popupDiv
            (
                 "/common/interfaceMonitoringKey.do"
                 , ""
                 , null
                 , "false"
                 , "interfaceMonitoringKey"
            );
        }
    	else {
	    	var popUpObj = Common.popupDiv
	        (
	             "/common/interfaceMonitoringDtm.do"
	             , ""
	             , null
	             , "false"
	             , "interfaceMonitoringDtm"
	        );
    	}
    });

    AUIGrid.bind(grdIf, "ready", function(event) {
    	gridDataLength = AUIGrid.getGridData(grdIf).length; // 그리드 전체 행수 보관

//     	for(var idx = 0 ; idx < gridDataLength ; idx++){

//     	}
    });

    // 헤더 클릭 핸들러 바인딩(checkAll)
    //AUIGrid.bind(grdIf, "headerClick", headerClickHandler);

    AUIGrid.clearGridData(grdIf);
/*
    var currentFullDt = new Date();
    currentFullDt.setMonth(currentFullDt.getMonth()); */
    var beforeFullDt = new Date();
    beforeFullDt.setMonth(beforeFullDt.getMonth() - 1);

//    var currentDt = lpad(currentFullDt.getDate(),2,"0")+"/"+lpad(currentFullDt.getMonth()+1,2,"0")+"/"+currentFullDt.getFullYear();
    var beforeDt = lpad(beforeFullDt.getMonth(),2,"0")+"/"+beforeFullDt.getFullYear();

    $("#searchDate").val(beforeDt);
//    $("#toDate").val(currentDt);
    //공통코드 조회
    fn_commCodesearch();
    fn_commItfTypeSearch();

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
<p class="fav"><a href="#" class="click_add_on">Monitoring</a></p>
<h2>Interface Monitoring</h2>
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
    <col style="width:110px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Type</th>
    <td>
<!--     <input id="ifType" name="ifType" type="text" title="" value=""  placeholder="Type Code" class="" /> -->
    <select class="" style="width:130px;" id="ifType" name="ifType">
        <option value="">- All -</option>
    </select>
    </td>
    <th scope="row">Status</th>
    <td>
    <select class="" style="width:100px;" id="tranStatusCd" name="tranStatusCd">
        <option value="">- All -</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Search Date</th>
    <td colspan="3">
	    <div class="date_set"><!-- date_set start -->
		    <p><input id="searchDate" name="searchDate" type="text" title="" placeholder="MM/YYYY" class="j_date2" readonly /></p>
		    <!--<span>~</span>
		    <p><input id="toDate" name="toDate"  type="text" title="" placeholder="DD/MM/YYYY" class="j_date" readonly  /></p>
		     -->
	    </div><!-- date_set end -->
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<div class="divine_auto"><!-- divine_auto start -->
<aside class="title_line"><!-- title_line start -->
<h3 class="pt0">Interface Monitoring</h3>
</aside><!-- title_line end -->

<article class="grid_wrap autoHeight"><!-- grid_wrap start -->
    <div id="grdIf"  style="height:390px;"></div>
</article><!-- grid_wrap end -->

<!-- </div> -->

</div><!-- divine_auto end -->


</section><!-- search_result end -->

</section><!-- content end -->