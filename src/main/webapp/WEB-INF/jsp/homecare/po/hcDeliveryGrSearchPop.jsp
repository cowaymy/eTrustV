<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js"></script>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-body-panel table tr:hover {
    background:#D9E5FF;
    color:#000;
}
.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
    background:#D9E5FF;
    color:#000;
}

</style>
<script type="text/javaScript">

var pCdcDs = [];
<c:forEach var="obj" items="${cdcList}">
  pCdcDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", address:"${obj.address}", telNo:"${obj.telNo}"});
</c:forEach>

var vendorDs = [];
<c:forEach var="obj" items="${vendorList}">
  vendorDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}"});
</c:forEach>

var toDay = "${toDay}";

var popupObj;
var grInfoPopGridId;

var grInfoLayout = [
         {dataField:"hmcDelvryNo", headerText:"Delivery No", width:140}
        , {dataField:"delvryQty", headerText:"DELVRY QTY", width:100
            , dataType:"numeric"
            , formatString:"#,##0"
            , style:"aui-grid-user-custom-right"
        }
        , {dataField:"delvryGiDt", headerText:"Delivery GI Date", width:120, editable:false
            , dataType:"date"
            , dateInputFormat:"dd/mm/yyyy"  // 실제 데이터의 형식 지정
            , formatString:"dd/mm/yyyy"     // 실제 데이터 형식을 어떻게 표시할지 지정
        }
        , {dataField:"poNo", headerText:"PO No", width:150}
        , {dataField:"vendor", headerText:"Supplier", width:200}
        , {dataField:"vendorId", headerText:"Supplier", width:200, visible:false}
];

var grInfoPros = {
		usePaging : true,
		pageRowCount : 25,
		useGroupingPanel : false,
        editable : false,
        showStateColumn : false,
        selectionMode : "singleCell",
        showRowNumColumn : true,
        enableRestore: true,
};

$(document).ready(function(){
    // Moblie Popup Setting
    Common.setMobilePopup(true, false, 'grSearchPopGrid');

    grInfoPopGridId = GridCommon.createAUIGrid("grSearchPopGrid", grInfoLayout, null, grInfoPros);
    AUIGrid.setGridData(grInfoPopGridId, []);

    doDefCombo(pCdcDs, '', 'pCdc', 'S', '');
    doDefCombo(vendorDs, '', 'pMemAccId', 'S', '');

    $("#pMemAccId").val("${zMemAccId}");

    if( js.String.isEmpty($("#pDlvGiDtFrom").val()) ){
        $("#pDlvGiDtFrom").val("${oneMonthBf}");
    }
    if( js.String.isEmpty($("#pDlvGiDtTo").val()) ){
        $("#pDlvGiDtTo").val("${toDay}");
    }

    $("#btnSearchPopSearch").click(function(){
        if(js.String.isEmpty($("#pCdc").val())){
            Common.alert("Please, check the mandatory value.");
            return ;
        }

        // 날짜형식 체크
        var sValidDtFrom = $("#pDlvGiDtFrom").val();
        var sValidDtTo = $("#pDlvGiDtTo").val();

        var date_pattern = /^(0[1-9]|[12][0-9]|3[0-1])\/(0[1-9]|1[012])\/(19|20)\d{2}$/;
        if( !date_pattern.test(sValidDtFrom)) {
            Common.alert("Please check the date format.");
            return ;
        }
        if( !date_pattern.test(sValidDtTo)) {
            Common.alert("Please check the date format.");
            return ;
        }

    	var url = "/homecare/po/hcDeliveryGrSearchPop/selectDeliveryGrSearchPop.do";
        var param = $("#searchPopForm").serializeObject();
        param.pMemAccId = $("#pMemAccId").val();

        AUIGrid.setGridData(grInfoPopGridId, []);

        Common.ajax("POST" , url , param , function(data){
        	if(data.total > 0){
        	    AUIGrid.setGridData(grInfoPopGridId, data.dataList);
        	}
        });

    });

    $("#btnSearchConfirm").click(function(){
    	var selectedItems = AUIGrid.getSelectedItems(grInfoPopGridId);
    	// Moblie Popup Setting
        if(Common.checkPlatformType() == "mobile") {
            if( typeof(opener.fn_SearchPopClose) != "undefined" ){
                opener.fn_SearchPopClose(selectedItems[0].item);
                window.close();
            }else{
                window.close();
            }
        } else {
            fn_SearchPopClose(selectedItems[0].item);
            $('#_divSearchPop').remove();
        }
    });

    $("#btnSearchClose").click(function(){
    	if(Common.checkPlatformType() == "mobile") {
    		window.close();
    	} else {
            $('#_divSearchPop').remove();
        }
    });

    AUIGrid.bind(grInfoPopGridId, "cellDoubleClick", function(event) {
        if(Common.checkPlatformType() == "mobile") {
            if( typeof(opener.fn_SearchPopClose) != "undefined" ){
                opener.fn_SearchPopClose(event.item);
                window.close();
            }else{
                window.close();
            }
        } else {
            fn_SearchPopClose(event.item);
            $('#_divSearchPop').remove();
        }
    });

});


</script>

<div id="popup_wrap1" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>HomeCare Delivery Search</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="btnSearchPopSearch"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue2"><a id="btnSearchConfirm" >Confirm</a></p></li>
    <li><p class="btn_blue2"><a id="btnSearchClose" >Close</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

    <form id="searchPopForm" method="POST">
        <table class="type1">
	        <caption>search table</caption>
	        <colgroup>
	            <col style="width:140px" />
	            <col style="width:*" />
	        </colgroup>
	        <tbody>
	                <tr>
	                   <th scope="row"><span style="color:red">*</span>CDC</th>
	                   <td >
	                       <select id="pCdc" name="pCdc" placeholder="" class="w100p" />
	                   </td>
	                </tr>
	                <tr>
	                   <th scope="row"><span style="color:red">*</span>Delivery GI Date</th>
	                   <td >
	                       <div class="date_set w100p">
                                <!-- date_set start -->
                                <p>
                                    <input id="pDlvGiDtFrom" name="sDlvGiDtFrom" type="text" title="PO start Date" placeholder="DD/MM/YYYY" class="j_date">
                                </p>
                                <span> To </span>
                                <p>
                                    <input id="pDlvGiDtTo" name="sDlvGiDtTo" type="text" title="PO End Date" placeholder="DD/MM/YYYY" class="j_date">
                                </p>
                            </div>
	                   </td>
	                </tr>
	                <tr>
	                    <th scope="row">PO No</th>
                        <td>
                            <input type="text" id="pPoNo" name="pPoNo" placeholder="" class="w100p" >
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Supplier</th>
                        <td>
                           <select id="pMemAccId" name="pMemAccId" title="" placeholder="" class="w100p" >
                        </td>
	                </tr>
	        </tbody>
        </table>
    </form>

    <section class="search_result">
        <article class="grid_wrap">
            <div id="grSearchPopGrid" class="autoGridHeight"></div>
        </article>
    </section>

</section>
</div>