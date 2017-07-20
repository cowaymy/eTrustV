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

// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){
    // AUIGrid 그리드를 생성합니다.
    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout);
    
    /*var auiGridProps = {
            selectionMode : "multipleCells",
            enableSorting : true,               // 정렬 사용            
            editable : true,                       // 편집 가능 여부 (기본값 : false)
            enableMovingColumn : true,      // 칼럼 이동 가능 설정
            wrapSelectionMove : true         // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부            
    };

    // 그리드 생성
    myGridID = AUIGrid.create("#grid_wrap", columnLayout, auiGridProps);*/
    
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
        headerText : "OrgCode",
        editable : false
    }, {
        dataField : "tGrpCode",
        headerText : "Grp Code",
        editable : false
    }, {
        dataField : "tDeptCode",
        headerText : "Dept Code",
        editable : false
    }, {
        dataField : "memCode",
        headerText : "Cody Code",
        editable : false
    }, {
        dataField : "sUnit",
        headerText : "Unit",
        editable : false,
        dataType:"numeric"
    }, {
        dataField : "sLmos",
        headerText : "Pre-Out",
        editable : false,
        width : 180,
        dataType:"numeric", 
        formatString:"###0.#"
    }, {
        dataField : "sCmChg",
        headerText : "Charges",
        editable : false,
        width : 180,
        dataType:"numeric", 
        formatString:"###0.#"
    }, {
        dataField : "sClCtg",
        headerText : "Target",
        editable : false,
        width : 180,
        dataType:"numeric", 
        formatString:"###0.#"
    }, {
        dataField : "sCol",
        headerText : "Collection",
        editable : false,
        width : 180,dataType:"numeric", 
        formatString:"###0.#"
    }, {
        dataField : "sAdj",
        headerText : "Adjustment",
        editable : false,
        width : 180,
        dataType:"numeric"
    },{
        dataField : "sOut",
        headerText : "Outstanding",
        editable : false,
        width : 180,
        dataType : "numeric", 
        formatString : "#,##0.##"
    },{
        dataField : "sOutRate",
        headerText : "Out Rate",
        editable : false,
        width : 120,
        dataType : "numeric", 
        style : "my-custom-up",
        formatString : "#,##0.##"
    }];
    
// ajax list 조회.
    function searchList()
    {
    	   Common.ajax("GET","/payment/selectRentalCollectionByBSList.do",$("#searchForm").serialize(), function(result){
    		AUIGrid.setGridData(myGridID, result);
    	});
    }
</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Payment</li>
        <li>Rental Collection</li>
        <li>Organization By BS Account</li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Organization By BS Account</h2>   
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="#" onClick="searchList()"><span class="search"></span>Search</a></p></li>
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
                        <td><input type="text" title="orgCode" id="orgCode" name="orgCode" placeholder="Org Code" /></td>
                        <th scope="row">Grp Code</th>
                        <td><input type="text" title="grpCode" id="grpCode" name="grpCode"  placeholder="Grp Code"/></td>
                    </tr>
                    <tr>
                        <th scope="row">Dept Code</th>
                        <td><input type="text" title="deptCode" id="deptCode" name="deptCode"  placeholder="Dept Code"/></td>
                        <th scope="row">Member Code</th>
                        <td><input type="text" title="memCode" id="memCode" name="memCode"  placeholder="Member Code"/></td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->
        </form>
    </section>
    <!-- search_table end -->

    <!-- search_result start -->
    <section class="search_result">
        <!-- grid_wrap start -->
        <article id="grid_wrap" class="grid_wrap"></article>
        <!-- grid_wrap end -->

    </section>
    <!-- search_result end -->

</section>
<!-- content end -->