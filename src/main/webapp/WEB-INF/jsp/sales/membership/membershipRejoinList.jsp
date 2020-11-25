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

        /* $("#orgCode").val("${orgCode}");
        $("#orgCode").attr("class", "w100p readonly");
        $("#orgCode").attr("readonly", "readonly"); */

    }else if("${SESSION_INFO.memberLevel}" =="2"){

        $("#orgCode").val("${orgCode}");
        $("#orgCode").attr("class", "w100p readonly");
        $("#orgCode").attr("readonly", "readonly");

        $("#grpCode").val("${grpCode}");
        $("#grpCode").attr("class", "w100p readonly");
        $("#grpCode").attr("readonly", "readonly");

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
    }

    var gridPros = {
            showStateColumn : false,
            wordWrap : true,
            headerHeight :40,
            fixedColumnCount : 5,
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
	    , { dataField : "totalExpired", headerText : "<spring:message code='sal.title.totExp'/>", width : '8%' }
	    , { dataField : "totalFreshExpired", headerText : "<spring:message code='sal.title.totFreshExp'/>", width : '11%' }
	    , { dataField : "totalFreshExpiredLast", headerText : "<spring:message code='sal.title.totFreshExpLast'/>", width : '11%' }
	    , { dataField : "totalFreshExpiredLast2", headerText : "<spring:message code='sal.title.totFreshExpLast2'/>", width : '11%' }
	    , { dataField : "totalFreshExpired3m", headerText : "<spring:message code='sal.title.totFreshExpAvg'/>", width : '10%' }
	    , { dataField : "svmByOwn", headerText : "<spring:message code='sal.title.svmOwn'/>", width : '8%' }
	    , { dataField : "svmByOther", headerText : "<spring:message code='sal.title.svmOther'/>", width : '8%' }
	    , { dataField : "extradeByOwn", headerText : "<spring:message code='sal.title.exTradeOwn'/>", width : '10%' }
	    , { dataField : "extradeByOther", headerText : "<spring:message code='sal.title.extradeOther'/>", width : '10%' }
	    , { dataField : "rejoinRate", headerText : "<spring:message code='sal.title.rejoinPercent'/>",dataType : "numeric",formatString : "###0.00", width : '7%'}
    ];

    // ajax list 조회.
    function searchList(){
    	   Common.ajax("GET","/sales/membership/selectRejoinList",$("#searchForm").serialize(), function(result){
    		   console.log(result);
    		AUIGrid.setGridData(myGridID, result);
    	});
    }

    function fn_clear(){
        $("#searchForm")[0].reset();
    }

    function fn_excelDown() {
      GridCommon.exportTo("grid_wrap", "xlsx", "RejoinSummaryRaw");
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
        <h2>Membership Rejoin</h2>
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