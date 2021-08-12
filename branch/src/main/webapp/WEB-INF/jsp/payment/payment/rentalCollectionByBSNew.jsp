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

$(document).ready(function(){

    var gridPros = {
            // 편집 가능 여부 (기본값 : false)
            editable : false,

            // 상태 칼럼 사용
            showStateColumn : false
    };
	myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);

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
        dataType:"numeric"
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
    }];

    // ajax list 조회.
    function searchList(){
    	   Common.ajax("GET","/payment/selectRentalCollectionByBSNewList",$("#searchForm").serialize(), function(result){
    		   console.log(result);
    		AUIGrid.setGridData(myGridID, result);
    	});
    }

    function fn_clear(){
        $("#searchForm")[0].reset();
    }

    function fn_excelDown() {
      GridCommon.exportTo("grid_wrap", "xlsx", "RC by HS");
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
        <!-- grid_wrap end -->

    </section>
    <!-- search_result end -->

</section>
<!-- content end -->