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
var memLvlData = [ {"codeId": "1","codeName": "GCM"}
							,{"codeId": "2","codeName": "SCM"}
							,{"codeId": "3","codeName": "CM"}
							,{"codeId": "4","codeName": "Cody"}];



$(document).ready(function(){


	// Remove upper level
	memLvlData.splice(0,'${SESSION_INFO.memberLevel}' - 1) ;

	doDefCombo(memLvlData, '${SESSION_INFO.memberLevel}' ,'memLvl', 'S', '');

    if("${SESSION_INFO.memberLevel}" =="1"){

        $("#orgCode").val("${orgCode}");
        $("#orgCode").attr("class", "w100p readonly");
        $("#orgCode").attr("readonly", "readonly");


        $("#V_ORGCODE").val("${orgCode}");
        $("#V_ORGCODE").attr("class", "w100p readonly");
        $("#V_ORGCODE").attr("readonly", "readonly");

    }else if("${SESSION_INFO.memberLevel}" =="2"){

        $("#orgCode").val("${orgCode}");
        $("#orgCode").attr("class", "w100p readonly");
        $("#orgCode").attr("readonly", "readonly");

        $("#grpCode").val("${grpCode}");
        $("#grpCode").attr("class", "w100p readonly");
        $("#grpCode").attr("readonly", "readonly");

        $("#V_ORGCODE").val("${orgCode}");
        $("#V_ORGCODE").attr("class", "w100p readonly");
        $("#V_ORGCODE").attr("readonly", "readonly");

        $("#V_GRPCODE").val("${grpCode}");
        $("#V_GRPCODE").attr("class", "w100p readonly");
        $("#V_GRPCODE").attr("readonly", "readonly");

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

        $("#V_ORGCODE").val("${orgCode}");
        $("#V_ORGCODE").attr("class", "w100p readonly");
        $("#V_ORGCODE").attr("readonly", "readonly");

        $("#V_GRPCODE").val("${grpCode}");
        $("#V_GRPCODE").attr("class", "w100p readonly");
        $("#V_GRPCODE").attr("readonly", "readonly");

        $("#V_DEPTCODE").val("${deptCode}");
        $("#V_DEPTCODE").attr("class", "w100p readonly");
        $("#V_DEPTCODE").attr("readonly", "readonly");



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

        $("#memLvl").attr("class", "w100p readonly");
        $("#memLvl").attr("readonly", "readonly");

        $("#V_ORGCODE").val("${orgCode}");
        $("#V_ORGCODE").attr("class", "w100p readonly");
        $("#V_ORGCODE").attr("readonly", "readonly");

        $("#V_GRPCODE").val("${grpCode}");
        $("#V_GRPCODE").attr("class", "w100p readonly");
        $("#V_GRPCODE").attr("readonly", "readonly");

        $("#V_DEPTCODE").val("${deptCode}");
        $("#V_DEPTCODE").attr("class", "w100p readonly");
        $("#V_DEPTCODE").attr("readonly", "readonly");
    }

    var gridPros = {
            showStateColumn : false,
            wordWrap : true,
            headerHeight :40,
            fixedColumnCount : 5,
            editable : false
    };
	myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);

});

	// AUIGrid 칼럼 설정
	var columnLayout = [
	      { dataField : "orgCode", headerText : "<spring:message code='sal.text.orgCode'/>", width : '7%' }
	    , { dataField : "grpCode", headerText : "<spring:message code='sal.text.grpCode'/>", width : '7%' }
	    , { dataField : "deptCode", headerText : "<spring:message code='sal.text.detpCode'/>", width : '7%' }
	    , { dataField : "memCode", headerText : "<spring:message code='sal.title.codyCode'/>", width : '7%' }
	    , { dataField : "memLvl", headerText : "<spring:message code='sal.title.memLvl'/>", width : '8%' }
	    , { dataField : "totalExpiredTarget", headerText : "<spring:message code='sal.title.totExpTarget'/>", width : '8%' }
	    , { dataField : "totalFreshExpiredTarget", headerText : "<spring:message code='sal.title.totFreshExpTarget'/>", width : '8%' }
	    , { dataField : "totalEarlyExtradeByOwn", headerText : "<spring:message code='sal.title.totEarlyExtradeByOwn'/>", width : '11%' }
	    , { dataField : "totalEarlyExtradeByOth", headerText : "<spring:message code='sal.title.totEarlyExtradeByOth'/>", width : '11%' }
	    , { dataField : "totalFreshExtradeByOwn", headerText : "<spring:message code='sal.title.totFreshExtradeByOwn'/>", width : '8%' }
	    , { dataField : "totalFreshExtradeByOth", headerText : "<spring:message code='sal.title.totFreshExtradeByOth'/>", width : '8%' }
	    , { dataField : "totalExtradeByOwn", headerText : "<spring:message code='sal.title.totExtradeByOwn'/>", width : '10%' }
	    , { dataField : "totalExtradeByOth", headerText : "<spring:message code='sal.title.totExtradeByOth'/>", width : '10%' }
	    , { dataField : "freshExtrade", headerText : "<spring:message code='sal.title.freshExtrade'/>",dataType : "numeric",formatString : "###0.00", width : '7%'}
	    , { dataField : "rejoinExtrade", headerText : "<spring:message code='sal.title.rejoinExtrade'/>",dataType : "numeric",formatString : "###0.00", width : '7%'}
    ];

    // ajax list 조회.
    function searchList(){
    	if("${SESSION_INFO.memberLevel}" =="1" && $("#orgCode").val() == ""){
            Common.alert("Please Key in Org code.");
            return false;
        }else if("${SESSION_INFO.memberLevel}" =="2" && $("#grpCode").val() == ""){
            Common.alert("Please Key in Group code.");
            return false;
        }else if("${SESSION_INFO.memberLevel}" =="3" && $("#deptCode").val() == ""){
            Common.alert("Please Key in Dept code.");
            return false;
        }else if("${SESSION_INFO.memberLevel}" =="4" && $("#deptCode").val() == ""){
            Common.alert("Please Key in Dept code.");
            return false;
        }

    	   Common.ajax("GET","/sales/membership/selectRejoinExtradeSummaryList",$("#searchForm").serialize(), function(result){
    		   console.log(result);
    		AUIGrid.setGridData(myGridID, result);
    	});
    }

    function fn_clear(){
        $("#searchForm")[0].reset();

        if("${SESSION_INFO.memberLevel}" =="1"){
            $("#orgCode").val("${orgCode}");
            $("#orgCode").attr("class", "w100p readonly");
            $("#orgCode").attr("readonly", "readonly");
        }else if("${SESSION_INFO.memberLevel}" =="2"){
            $("#orgCode").val("${orgCode}");
            $("#orgCode").attr("class", "w100p readonly");
            $("#orgCode").attr("readonly", "readonly");
            $("#grpCode").val("${grpCode}");
            $("#grpCode").attr("class", "w100p readonly");
            $("#grpCode").attr("readonly", "readonly");
            $("#V_ORGCODE").val("${orgCode}");
            $("#V_ORGCODE").attr("class", "w100p readonly");
            $("#V_ORGCODE").attr("readonly", "readonly");
            $("#V_GRPCODE").val("${grpCode}");
            $("#V_GRPCODE").attr("class", "w100p readonly");
            $("#V_GRPCODE").attr("readonly", "readonly");
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
            $("#V_ORGCODE").val("${orgCode}");
            $("#V_ORGCODE").attr("class", "w100p readonly");
            $("#V_ORGCODE").attr("readonly", "readonly");
            $("#V_GRPCODE").val("${grpCode}");
            $("#V_GRPCODE").attr("class", "w100p readonly");
            $("#V_GRPCODE").attr("readonly", "readonly");
            $("#V_DEPTCODE").val("${deptCode}");
            $("#V_DEPTCODE").attr("class", "w100p readonly");
            $("#V_DEPTCODE").attr("readonly", "readonly");
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
            $("#memLvl").attr("class", "w100p readonly");
            $("#memLvl").attr("readonly", "readonly");
            $("#V_ORGCODE").val("${orgCode}");
            $("#V_ORGCODE").attr("class", "w100p readonly");
            $("#V_ORGCODE").attr("readonly", "readonly");
            $("#V_GRPCODE").val("${grpCode}");
            $("#V_GRPCODE").attr("class", "w100p readonly");
            $("#V_GRPCODE").attr("readonly", "readonly");
            $("#V_DEPTCODE").val("${deptCode}");
            $("#V_DEPTCODE").attr("class", "w100p readonly");
            $("#V_DEPTCODE").attr("readonly", "readonly");
        }
    }

    function fn_excelDown() {
      GridCommon.exportTo("grid_wrap", "xlsx", "RejoinExtradeSummaryRaw");
    }
/*
      function fn_excelDown() {
      GridCommon.exportTo("grid_wrap", "xlsx", "RejoinListingRaw");
    } */

      hideViewPopup=function(val){
        $(val).hide();
    }

     var today = '${today}'
    function fn_openRawDataDownload(val){
        $('#rawData_wrap').show();

       if(val == "rejoinExtradeSummary" ){
            console.log("rejoinExtradeSummary");
            $("#rawDataHeader").text("Rejoin Extrade Summary Raw Data");
            $("#rawDataForm #reportFileName").val("/sales/RejoinExtradeSummaryRaw.rpt");
            $("#rawDataForm #reportDownFileName").val("RejoinExtradeSummaryRaw_" + today + ".xls");
        }
    }

     function fn_generate(){
         var option = { isProcedure : true };
         Common.report("rawDataForm", option);
     }

  //End Added
</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
        <h2>Membership Rejoin Extrade Summary</h2>
        <ul class="right_btns">
        <c:if test="${PAGE_AUTH.funcView == 'Y'}">
            <li><p class="btn_blue"><a href="#" onClick="searchList()"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
        </c:if>
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
                    <tr>
                        <th scope="row">Member Level</th>
                        <td><p><select id="memLvl" name="memLvl" class="w100p"></select></p></td>
                        <th scope="row"></th>
                        <td></td>
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
               <a href="javascript:fn_openRawDataDownload('rejoinExtradeSummary');">Rejoin Net Raw Data</a>
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
            <li><p class="btn_grid"><a href="#" onClick="fn_excelDown()"><spring:message code='sal.title.text.download'/></a></p></li>
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
                        <td colspan="3"><input type="text" id="V_GENDATE" name="V_GENDATE" title="Date" class="w100p j_date2" value="${dt}" /></td>
                    </tr>
                    <tr>
                        <th scope="row">Org Code</th>
                        <td colspan="3"><input type="text" id="V_ORGCODE" name="V_ORGCODE"  class="w100p " title="OrgCode" " /></td>
                    </tr>

                    <tr>
                        <th scope="row">Grp Code</th>
                        <td colspan="3"><input type="text" id="V_GRPCODE" name="V_GRPCODE"  class="w100p " title="GrpCode" " /></td>
                    </tr>
                    <tr>
                        <th scope="row">Dept Code</th>
                        <td colspan="3"><input type="text" id="V_DEPTCODE" name="V_DEPTCODE" class="w100p "  title="DeptCode" " /></td>
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