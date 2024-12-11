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
var excelGridID;
// Service type
var arrSrvTypeCode = [
                      {"codeId": "SS"  ,"codeName": "Self Service"},
                      {"codeId": "HS" ,"codeName": "Heart Service"}
                    ];


function loadMember(){
    if("${orgCode}"){

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

            $("#memCode").val("${SESSION_INFO.userName}");
            $("#memCode").attr("class", "w100p readonly");
            $("#memCode").attr("readonly", "readonly");
        }
    }
}

$(document).ready(function(){
	doDefCombo(arrSrvTypeCode, '', 'cmbSrvType', 'S', '');
    var gridPros = {
            // 편집 가능 여부 (기본값 : false)
            editable : false,

            // 상태 칼럼 사용
            showStateColumn : false
    };
	myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
    excelGridID = GridCommon.createAUIGrid("excel_grid_wrap", excelColumnLayout,null,gridPros);

	loadMember();

});

// AUIGrid 칼럼 설정
var columnLayout = [
    {
        dataField : "tOrgCode",
        headerText : "<spring:message code='pay.head.orgCode'/>",
        editable : false
    }, {
        dataField : "tGrpCode",
        headerText : "<spring:message code='pay.head.grpCode'/>",
        editable : false
    }, {
        dataField : "tDeptCode",
        headerText : "<spring:message code='pay.head.deptCode'/>",
        editable : false
    }, {
        dataField : "memCode",
        headerText : "<spring:message code='pay.head.codyCode'/>",
        editable : false
    }, {
        dataField : "sUnit",
        headerText : "<spring:message code='pay.head.unit'/>",
        editable : false,
        width : 80,
        dataType:"numeric"
    }, {
    	dataField : "srvType",
        headerText : "<spring:message code='sales.srvType'/>",
        width : 100,
        editable : false
    }, {
        dataField : "indOrd",
        headerText : "Individual Order",
        editable : false,
        width : 150,
        dataType:"numeric"
    }, {
        dataField : "corpOrd",
        headerText : "Corporate Order",
        editable : false,
        width : 150,
        dataType:"numeric"
    }, {
        dataField : "corpRatio",
        headerText : "Corporate Ratio",
        editable : false,
        width : 150,
        dataType:"numeric",
        formatString:"###0.##"
    }, {
        dataField : "sClCtg",
        headerText : "<spring:message code='pay.head.target'/>",
        editable : false,
        width : 100,
        dataType:"numeric",
        formatString:"###0.#"
    }, {
        dataField : "sCol",
        headerText : "<spring:message code='pay.head.collection'/>",
        editable : false,
        width : 100,
        dataType:"numeric",
        formatString:"###0.#"
    }, {
        dataField : "rcPrct",
        headerText : "RC%",
        editable : false,
        width : 100,
        dataType:"numeric"
    }, {
        dataField : "adRatio",
        headerText : "AD Ratio%",
        editable : false,
        width : 100,
        dataType:"numeric"
    }];

var excelColumnLayout = [
                         {
                             dataField : "tOrgCode",
                             headerText : "<spring:message code='pay.head.orgCode'/>",
                             editable : false
                         }, {
                             dataField : "tGrpCode",
                             headerText : "<spring:message code='pay.head.grpCode'/>",
                             editable : false
                         }, {
                             dataField : "tDeptCode",
                             headerText : "<spring:message code='pay.head.deptCode'/>",
                             editable : false
                         }, {
                             dataField : "memCode",
                             headerText : "<spring:message code='pay.head.codyCode'/>",
                             editable : false
                         }, {
                             dataField : "sUnit",
                             headerText : "<spring:message code='pay.head.unit'/>",
                             editable : false,
                             dataType:"numeric"
                         }, {
                             dataField : "srvType",
                             headerText : "<spring:message code='sales.srvType'/>",
                             editable : false
                         }, {
                             dataField : "indOrd",
                             headerText : "Individual Order",
                             editable : false,
                             width : 180,
                             dataType:"numeric"
                         }, {
                             dataField : "corpOrd",
                             headerText : "Corporate Order",
                             editable : false,
                             width : 180,
                             dataType:"numeric"
                         }, {
                             dataField : "corpRatio",
                             headerText : "Corporate Ratio",
                             editable : false,
                             width : 180,
                             dataType:"numeric",
                             formatString:"###0.##"
                         }, {
                             dataField : "sClCtg",
                             headerText : "<spring:message code='pay.head.target'/>",
                             editable : false,
                             width : 180,
                             dataType:"numeric",
                             formatString:"###0.#"
                         }, {
                             dataField : "sCol",
                             headerText : "<spring:message code='pay.head.collection'/>",
                             editable : false,
                             width : 180,dataType:"numeric",
                             formatString:"###0.#"
                         }, {
                             dataField : "rcPrct",
                             headerText : "RC%",
                             editable : false,
                             width : 180,
                             dataType:"numeric"
                         }, {
                             dataField : "adRatio",
                             headerText : "AD Ratio%",
                             editable : false,
                             width : 180,
                             dataType:"numeric"
                         }, {
                             dataField : "cmName",
                             headerText : "CM Name",
                             editable : false
                         }, {
                             dataField : "branch",
                             headerText : "Branch",
                             editable : false
                         }, {
                             dataField : "region",
                             headerText : "Region",
                             editable : false
                         }];

    // ajax list 조회.
    function searchList(){
    	   Common.ajax("GET","/payment/selectRentalCollectionByBSNewList",$("#searchForm").serialize(), function(result){
    		console.log('result:', result);
    		AUIGrid.setGridData(myGridID, result);
    		AUIGrid.setGridData(excelGridID, result);
    	});
    }

    function fn_clear(){
        $("#searchForm")[0].reset();
        loadMember();
    }

    function fn_excelDown() {
      GridCommon.exportTo("excel_grid_wrap", "xlsx", "RC by HS");
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
        <h2>RC by HS</h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="#" onClick="searchList()"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm">
            <input type="hidden" id="memType" name="memType" value="2">

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
                        <th scope="row"><spring:message code='sales.srvType'/></th>
                        <td><select class="w100p" id="cmbSrvType" name="cmbSrvType"></td>
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
            <li><p class="btn_grid"><a href="#" onClick="fn_excelDown()"><spring:message code='service.btn.Generate'/></a></p></li>
        </c:if>
    </ul>
    <!-- search_result start -->
    <section class="search_result">
        <!-- grid_wrap start -->
        <article id="grid_wrap" class="grid_wrap"></article>
        <article id="excel_grid_wrap" class="grid_wrap" style="display: none;"></article>

        <!-- grid_wrap end -->

    </section>
    <!-- search_result end -->

</section>
<!-- content end -->