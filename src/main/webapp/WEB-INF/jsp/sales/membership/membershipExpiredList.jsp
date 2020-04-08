<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<style type="text/css">
.my-custom-up div{
    color:#FF0000;
}
</style>
<script type="text/javaScript">
//AUIGrid 그리드 객체
var myGridID;
var expiredPeriodData = [
              {"codeId": "0","codeName": "Fresh"},
              {"codeId": "1","codeName": "1"},
              {"codeId": "2","codeName": "2"},
              {"codeId": "3","codeName": "3"},
              {"codeId": "4","codeName": "4"},
              {"codeId": "5","codeName": "5"},
              {"codeId": "6","codeName": "6"},
              {"codeId": "7","codeName": "7 above"}
              ];
var today = '${today}'

$(document).ready(function(){

	doGetCombo('/common/selectCodeList.do', '8', '',  'custType', 'S');
	doGetComboOrder('/common/selectCodeList.do', '10', 'CODE_ID',   '', 'listAppType', 'M', 'fn_multiCombo');
	doDefCombo(expiredPeriodData, '' ,'expiredPeriod', 'M', 'fn_multiCombo');

	if("${SESSION_INFO.userTypeId}" == "1" ||"${SESSION_INFO.userTypeId}" == "2" ){
        $("#table1").show();
    }

    if("${SESSION_INFO.memberLevel}" =="1"){

        $("#orgCode").val("${orgCode}");
        $("#orgCode").attr("class", "w100p readonly");
        $("#orgCode").attr("readonly", "readonly");

        /* doDefCombo(expiredPeriodData, '7' ,'expiredPeriod', 'M', 'fn_multiCombo');
        $("#expiredPeriod").multipleSelect("disable"); */


    }else if("${SESSION_INFO.memberLevel}" =="2"){

        $("#orgCode").val("${orgCode}");
        $("#orgCode").attr("class", "w100p readonly");
        $("#orgCode").attr("readonly", "readonly");


        $("#grpCode").val("${grpCode}");
        $("#grpCode").attr("class", "w100p readonly");
        $("#grpCode").attr("readonly", "readonly");

        /* doDefCombo(expiredPeriodData, '7' ,'expiredPeriod', 'M', 'fn_multiCombo');
        $("#expiredPeriod").multipleSelect("disable"); */

    }else if("${SESSION_INFO.memberLevel}" =="3"){

        $("#orgCode").val("${orgCode}");
        $("#orgCode").attr("class", "w100p readonly");
        $("#orgCode").attr("readonly", "readonly");

        $("#grpCode").val("${grpCode}");
        $("#grpCode").attr("class", "w100p readonly");
        $("#grpCode").attr("readonly", "readonly");

        $("#deptCode").val("${deptCode}");
        $("#deptCode").attr("class", "w100p readonly");
        $("#deptCode").attr("readonly", "readonly");

        /* doDefCombo(expiredPeriodData, '7' ,'expiredPeriod', 'M', 'fn_multiCombo');
        $("#expiredPeriod").multipleSelect("disable"); */

    }else if("${SESSION_INFO.memberLevel}" =="4"){

        $("#orgCode").val("${orgCode}");
        $("#orgCode").attr("class", "w100p readonly");
        $("#orgCode").attr("readonly", "readonly");

        $("#grpCode").val("${grpCode}");
        $("#grpCode").attr("class", "w100p readonly");
        $("#grpCode").attr("readonly", "readonly");

        $("#deptCode").val("${deptCode}");
        $("#deptCode").attr("class", "w100p readonly");
        $("#deptCode").attr("readonly", "readonly");

        $("#memCode").val("${memCode}");
        $("#memCode").attr("class", "w100p readonly");
        $("#memCode").attr("readonly", "readonly");
    }

    var gridPros = {
            showStateColumn : false
    };
	myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);

});

	// AUIGrid 칼럼 설정
	var columnLayout = [
	        { dataField : "expiredPeriod", headerText : "<spring:message code='sal.title.expiredPeriod'/>" }
		  , { dataField : "expiryDt", headerText : "<spring:message code='sal.title.expiredDate'/>" }
		  , { dataField : "salesOrdNo", headerText : "<spring:message code='sal.title.ordNo'/>" }
		  , { dataField : "memCode", headerText : "<spring:message code='sal.title.memberCode'/>" }
		  , { dataField : "memberName", headerText : "<spring:message code='sal.title.memberName'/>" }
		  , { dataField : "custName", headerText : "<spring:message code='sal.title.custName'/>" }
		  , { dataField : "telM1", headerText : "<spring:message code='sal.text.telM'/>" }
		  , { dataField : "telR", headerText : "<spring:message code='sal.text.telR'/>" }
		  , { dataField : "telO", headerText : "<spring:message code='sal.text.telO'/>" }
		  , { dataField : "custType", headerText : "<spring:message code='sal.title.custType'/>" }
		  , { dataField : "collection", headerText : "<spring:message code='sal.title.text.collectionAmt'/>" }
		  , { dataField : "target", headerText : "<spring:message code='sal.title.target'/>" }
		  , { dataField : "installState", headerText : "<spring:message code='sal.title.state'/>" }
		  , { dataField : "installArea", headerText : "<spring:message code='sal.title.area'/>" }
    ];

    // ajax list 조회.
    function searchList(){
    	   Common.ajax("GET","/sales/membership/selectExpiredMembershipList",$("#searchForm").serialize(), function(result){
    		   console.log(result);
    		AUIGrid.setGridData(myGridID, result);
    	});
    }

    function fn_clear(){
        $("#searchForm")[0].reset();
    }

    function fn_excelDown() {
      GridCommon.exportTo("grid_wrap", "xlsx", "RejoinListingRaw");
    }

    function fn_multiCombo(){
        $('#listAppType').change(function() {
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });
        $('#listAppType').multipleSelect("checkAll");

        $('#expiredPeriod').change(function() {
        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '100%'
        });

    }

    hideViewPopup=function(val){
        $(val).hide();
    }

    function fn_openRawDataDownload(val){
    	$('#rawData_wrap').show();

    	if(val == "rejoinTarget" ){
    		console.log("rejoinTarget");
    		$("#rawDataHeader").text("Rejoin Target Raw Data");
    		$("#rawDataForm #reportFileName").val("/sales/RejoinTargetRaw.rpt");
    		$("#rawDataForm #reportDownFileName").val("RejoinTargetRawData_" + today + ".xls");

    	}else if(val == "rejoinNet" ){
    		console.log("rejoinNet");
    		$("#rawDataHeader").text("Rejoin Net Raw Data");
    		$("#rawDataForm #reportFileName").val("/sales/RejoinNetRaw.rpt");
            $("#rawDataForm #reportDownFileName").val("RejoinNetRawData_" + today + ".xls");
        }

    }

    function fn_generate(){
        var option = { isProcedure : true };
        Common.report("rawDataForm", option);
    }
</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
        <h2>Membership Rejoin Listing</h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="#" onClick="searchList()"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm">
            <!-- table start -->
            <table class="type1">
                <caption>search table</caption>
                <colgroup>
                    <col style="width:144px" />
                    <col style="width:*" />
                    <col style="width:144px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Expired Period</th>
                        <td><select id="expiredPeriod" name="expiredPeriod" class="multy_select w100p" multiple="multiple"></select></td>
                        <th scope="row">Application Type</th>
                        <td><select id="listAppType" name="listAppType" class="multy_select w100p" multiple="multiple"></select></td>
                    </tr>
                    <tr>
                        <th scope="row">Customer Type</th>
                        <td><select  id="custType" name="custType" class="w100p"></select></td>
                        <th scope="row"></th>
                        <td></td>
                    </tr>
                    <tr>
                        <th scope="row">Install State</th>
                        <td><input type="text" id="installState" name="installState" class="w100p" /></td>
                        <th scope="row">Install Area</th>
                        <td><input type="text"  id="installArea" name="installArea"  class="w100p"/></td>
                    </tr>
                    <tr>
                        <th scope="row">Org Code</th>
                        <td><input type="text" title="orgCode" id="orgCode" name="orgCode" placeholder="Org Code" class="w100p" /></td>
                        <th scope="row">Grp Code</th>
                        <td><input type="text" title="grpCode" id="grpCode" name="grpCode"  placeholder="Grp Code" class="w100p"/></td>
                    </tr>
                    <tr>
                        <th scope="row">Dept Code</th>
                        <td><input type="text" title="deptCode" id="deptCode" name="deptCode"  placeholder="Dept Code" class="w100p"/></td>
                        <th scope="row">Member Code</th>
                        <td><input type="text" title="memCode" id="memCode" name="memCode"  placeholder="Member Code" class="w100p"/></td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->
        </form>
    </section>
    <!-- search_table end -->
<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
	<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
	<dl class="link_list">
	  <dt>Link</dt>
	  <dd>
	  <ul class="btns">
	      <li><p class="link_btn">
	           <a href="javascript:fn_openRawDataDownload('rejoinTarget');"><spring:message code='sales.btn.rejoinTarget'/></a>
	      </p></li>
	      <li><p class="link_btn">
	           <a href="javascript:fn_openRawDataDownload('rejoinNet');"><spring:message code='sales.btn.rejoinNet'/></a>
	      </p></li>

	  </ul>
	    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
	    </dd>
	</dl>
	</aside><!-- link_btns_wrap end -->
</c:if>
    <!-- link_btns_wrap end -->
    <ul class="right_btns">
        <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
            <li><p class="btn_grid"><a href="#" onClick="fn_excelDown()"><spring:message code='sal.btn.generate'/></a></p></li>
        </c:if>
    </ul>
    <!-- search_result start -->
    <section class="search_result">
        <!-- grid_wrap start -->
        <article id="grid_wrap" class="grid_wrap"></article>
        <!-- grid_wrap end -->

    </section>
    <!-- search_result end -->

</section>
<!-- content end -->

<!-------------------------------------------------------------------------------------
    POP-UP (RAWDATA)
-------------------------------------------------------------------------------------->
<div class="popup_wrap size_small" id="rawData_wrap" style="display:none;">
    <!-- pop_header start -->
    <header class="pop_header" id="new_pop_header">
        <h1 id="rawDataHeader"></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#rawData_wrap')">CLOSE</a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->

    <!-- pop_body start -->
    <form name="rawDataForm" id="rawDataForm"  method="post">
    <input type="hidden" id="reportFileName" name="reportFileName"  />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" />
    <input type="hidden" id="viewType" name="viewType" value="EXCEL"/>
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
                        <th scope="row"><spring:message code='sal.title.date'/></th>
                        <td colspan="3"><input type="text" id="V_GENDATE" name="V_GENDATE" title="Date" class="j_date2" value="${dt}" /></td>
                    </tr>
                   </tbody>
            </table>
        </section>
        <!-- search_table end -->

        <ul class="center_btns">
            <li><p class="btn_blue2"><a href="javascript:fn_generate();"><spring:message code='sal.btn.generate'/></a></p></li>
        </ul>
    </section>
    </form>
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->