<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var loyaltyRewardGridId, loyaltyRewardItmGridId;
var gridPros = {
        editable : false,
        showStateColumn : false
};
var statusData = [{"codeId": "1","codeName": "Active"},{"codeId": "4","codeName": "Completed"},{"codeId": "8","codeName": "Inactive"}];
var selectedGridValue, batchId;

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){
	doDefCombo(statusData, '' ,'status', 'S', '');

	uploadGrid = GridCommon.createAUIGrid("#uploadGrid", uploadLayout, "", gridPros);
	loyaltyRewardGridId = GridCommon.createAUIGrid("loyaltyRewardGrid_wrap", loyaltyRewardLayout,"",gridPros);
	loyaltyRewardItmGridId = GridCommon.createAUIGrid("loyaltyRewardItemGrid_wrap", loyaltyRewardDetailLayout,null,gridPros);

	AUIGrid.bind(loyaltyRewardGridId, "cellClick", function( event ){
        selectedGridValue = event.rowIndex;
        batchId = event.item.lrpBatchId;
    });

	AUIGrid.bind(loyaltyRewardGridId, "cellDoubleClick", function(event){
        Common.ajax("GET", "/sales/pos/selectLoyaltyRewardPointDetails.do", {"batchId":batchId}, function(result) {
            AUIGrid.setGridData(loyaltyRewardItmGridId, result);
            AUIGrid.resize(loyaltyRewardItmGridId,945, $(".grid_wrap").innerHeight());
            $("#view_wrap").show();
        });
    });
});

var uploadLayout = [
    {dataField : "0",headerText : "memCode"         , editable : true},
    {dataField : "1",headerText : "balanceCapped"   ,editable : true},
    {dataField : "2",headerText : "discount"        ,editable : true},
    {dataField : "3",headerText : "startDate"       ,editable : true},
    {dataField : "4",headerText : "endDate"         ,editable : true},
];

var loyaltyRewardLayout = [
    {dataField : "lrpBatchId"    ,headerText : "<spring:message code='sal.title.text.batchId'/>",editable : false,width: '15%'},
    {dataField : "stus"         ,headerText : "<spring:message code='sal.title.status'/>"       ,editable : false,width: '15%'},
    {dataField : "rem"          ,headerText : "<spring:message code='sal.title.remark'/>"       ,editable : false,width: '40%'},
    {dataField : "crtDt"        ,headerText : "<spring:message code='sal.title.crtDate'/>"      ,editable : false,width: '15%'},
    {dataField : "crtUserName"  ,headerText : "<spring:message code='sal.title.created'/>"      ,editable : false,width: '15%'}
];

var loyaltyRewardDetailLayout = [
    {dataField : "memCode"                ,headerText : "<spring:message code='sal.title.memberCode' />",editable : false,width: '12%'},
    {dataField : "lrpUplAmt"              ,headerText : "<spring:message code='sal.title.balanceCapped'/>",editable : false,width: '15%', dataType : "numeric", formatString : "#,##0.00"},
    {dataField : "lrpUplDiscountPercent"  ,headerText : "<spring:message code='sal.title.text.discount'/> (%)",editable : false,width: '12%'},
    {dataField : "startDt"                ,headerText : "<spring:message code='sal.title.stDate'/>"       ,editable : false,width: '13%'},
    {dataField : "endDt"                  ,headerText : "<spring:message code='sal.title.endDate'/>"       ,editable : false,width: '13%'},
    {dataField : "lrpBalanceAmt"          ,headerText : "<spring:message code='sal.title.balance'/>"       ,editable : false,width: '15%', dataType : "numeric", formatString : "#,##0.00"},
    {dataField : "rem"                    ,headerText : "<spring:message code='sal.title.remark'/>"       ,editable : false,width: '30%'},
    {dataField : "stus"                  ,headerText : "<spring:message code='sal.title.status'/>"       ,editable : false,width: '10%'},
];

function fn_uploadFile(){

	var formData = new FormData();

	if($("input[name=uploadfile]")[0].files[0] != undefined)
	{
	    formData.append("csvFile", $("input[name=uploadfile]")[0].files[0]);

	    Common.ajaxFile("/sales/pos/uploadLoyaltyRewardBulk.do", formData, function(result)    {
	    	Common.alert("Upload Successful", function(){
	    		$('#_btnClose').click();
	    		$('#_btnSearch').click();
	        });
	    });
	}else{
		Common.alert("File not found.");
	}
};

$(function(){
	$('#_btnSearch').click(function() {
		Common.ajax("GET","/sales/pos/selectLoyaltyRewardPointList.do", $("#frmSearch").serialize(), function(result){
            AUIGrid.setGridData(loyaltyRewardGridId, result);
        });
	});
	$('#_btnClear').click(function() {
        $('#frmSearch')[0].reset();
    });
	$('#_btnUpload').click(function(){
		$('#updResult_wrap').show();
	});
	$('#_btnClose').click(function(){
        $('#updResult_wrap').hide();
    });
	$('#view_wrap_close').click(function(){
	    $('#view_wrap').hide();
	});
});

function fn_getItmStatus(val){
    if(val == "4"){$('#pop_header h3').text('APPROVED TRANSACTION');}
    else if(val == "21"){$('#pop_header h3').text('FAILED TRANSACTIONS');}
    else{$('#pop_header h3').text('ALL TRANSACTIONS');}

    Common.ajax("GET", "/sales/pos/selectLoyaltyRewardPointDetails.do", {"batchId":batchId, "status":val}, function(result) {
        AUIGrid.setGridData(loyaltyRewardItmGridId, result);
    });
}

</script>
<body>
	<div id="wrap"><!-- wrap start -->
		<section id="content"><!-- content start -->
			<ul class="path">
			        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
			</ul>
			<aside class="title_line"><!-- title_line start -->
				<p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
				<h2>POS - Loyalty Reward</h2>
                <ul class="right_btns">
                    <li><p class="btn_blue"><a id="_btnUpload" href="#"><span class="upload"></span>Upload</a></p></li>
                    <li><p class="btn_blue"><a id="_btnSearch" href="#"><span class="search"></span>Search</a></p></li>
                    <li><p class="btn_blue"><a id="_btnClear" href="#"><span class="clear"></span>Clear</a></p></li>
                </ul>
			</aside><!-- title_line end -->
          <form id="frmSearch" name="frmSearch" action="#" method="post">
		<table class="type1"><!-- table start -->
			<caption>table</caption>
			<colgroup>
			    <col style="width:120px" />
			    <col style="width:*" />
			    <col style="width:120px" />
			    <col style="width:*" />
			</colgroup>
			<tbody>
                  <tr>
                    <th scope="row"><spring:message code='sal.title.text.batchId'/></th>
                         <td><input type="text" id="batchId" name="batchId" class="w50p" /></td>
				    <th scope="row"><spring:message code='sal.title.status'/></th>
				        <td><select id="status" name="status" class="w50p"></select></td>
				</tr>
			</tbody>
		</table><!-- table end -->
         </form>

		<section class="search_result">
		<article id="grid_wrap" class="grid_wrap mt10">
		     <div id="loyaltyRewardGrid_wrap" style="width:100%"></div>
		</article>
		 </section>
	</section><!-- container end -->
	<hr />
</div><!-- wrap end -->

<!-- popup_wrap start -->
<div class="popup_wrap" id="view_wrap" style="display:none">
    <header class="pop_header" id="pop_header">
        <h1>POS - Loyalty Reward Details</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" id="view_wrap_close">CLOSE</a></p></li>
        </ul>
    </header>
    <section class="pop_body">
    <h3></h3>
        <header class="pop_header" id="pop_header">
            <ul class="right_btns">
                <li><p class="btn_blue2"><a href="javascript:fn_getItmStatus('')">All Items</a></p></li>
                <li><p class="btn_blue2"><a href="javascript:fn_getItmStatus(4)">Valid Items</a></p></li>
                <li><p class="btn_blue2"><a href="javascript:fn_getItmStatus(21)">Invalid Items</a></p></li>
            </ul>
        </header>

        <section class="search_result">
            <article class="grid_wrap" >
                <div id="loyaltyRewardItemGrid_wrap" style="width: 100%; height: 360px; margin: 0px auto;"></div>
            </article>
        </section>
    </section>
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->

<div class="popup_wrap size_small" id="updResult_wrap" style="display:none;">
    <!-- pop_header start -->
    <header class="pop_header" id="updResult_pop_header">
        <h1>LOYALTY REWARD UPLOAD</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" id="_btnClose"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->

    <!-- pop_body start -->
    <form name="uploadForm" id="uploadForm"  method="post">
    <section class="pop_body">
        <!-- search_table start -->
        <section class="search_table">
            <!-- table start -->
            <table class="type1">
                <caption>table</caption>
                 <colgroup>
                    <col style="width:165px" />
                    <col style="width:*" />
                </colgroup>

                <tbody>
                    <tr>
                        <th scope="row">File</th>
                        <td>
                           <div class="auto_file"><!-- auto_file start -->
                            <input type="file" title="file add" id="uploadfile" name="uploadfile" accept=".csv"/>
                            </div><!-- auto_file end -->
                        </td>
                    </tr>
                   </tbody>
            </table>
        </section>

        <section class="search_result"><!-- search_result start -->
            <article class="grid_wrap"  id="uploadGrid" style="display:none;"></article>
        </section>

        <ul class="center_btns" >
            <li><p class="btn_blue2"><a href="javascript:fn_uploadFile();"><spring:message code='pay.btn.upload'/></a></p></li>
            <li><p class="btn_blue2"><a href="${pageContext.request.contextPath}/resources/download/sales/PosLoyaltyReward_Template.csv"><spring:message code='pay.btn.downloadCsvFormat'/></a></p></li>
        </ul>
    </section>
    </form>
    <!-- pop_body end -->
</div>
</body>