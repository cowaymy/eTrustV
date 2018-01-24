<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript">
var myGridID3;

//Start AUIGrid
$(document).ready(function() {

    // AUIGrid 그리드를 생성합니다.
    createAUIGrid3();
    fn_installationResult();


    
                  
});



    
function createAUIGrid3() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "stkCode",
        headerText : "Filter Code",
        editable : false,
        width : 120
    }, {
        dataField : "stkDesc",
        headerText : "Filter Name.",
        editable : false,
        width : 130
    }, {
        dataField : "bsResultPartQty",
        headerText : "Quantity",
        editable : false,
        width : 130
    }, {
        dataField : "bsResultFilterClm",
        headerText : "Claim",
        editable : false,
        width : 130
    }];
     // 그리드 속성 설정
    var gridPros = {

        // 페이징 사용
        usePaging : true,

        // 한 화면에 출력되는 행 개수 20(기본값:20)
        pageRowCount : 20,

        editable : true,

        showStateColumn : true,

        displayTreeOpen : true,


        headerHeight : 30,

        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        skipReadonlyColumns : true,

        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        wrapSelectionMove : true,

        // 줄번호 칼럼 렌더러 출력
        showRowNumColumn : true

    };

    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID3 = AUIGrid.create("#grid_wrap3", columnLayout, gridPros);
    
}







function fn_installationResult(){
    var jsonObj = {
            MresultId : $("#MresultId").val()
       };
       
    Common.ajax("GET", "/services/bs/hSMgtResultViewResultFilter.do",jsonObj, function(result) {
        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID3, result);
    });
    
}





function fn_winClose(){

    this.close();
}
</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>HS - View HS Result</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->



<form action="#" id="membeSponForm" method="post">
 <input type="hidden" value="<c:out value="${resultInfo.resultId}"/>" id="resultId"/>
 <input type="hidden" value="<c:out value="${resultInfo.allowComm}"/>" id="resultId"/>
 <input type="hidden" value="<c:out value="${resultInfo.isTradeIn}"/>" id="resultId"/>
 <input type="hidden" value="<c:out value="${resultInfo.requireSms}"/>" id="resultId"/>
 
<section class="search_table"><!-- search_table start -->
<form action="#" method="post">
<aside class="title_line mt20"><!-- title_line start -->
<h2>Hart Service Information</h2>
</aside><!-- title_line end -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:120px" />
    <col style="width:130px" />
    <col style="width:140px" />
    <col style="width:130px" />
    <col style="width:140px" />
    <col style="width:140px" />        
</colgroup>
<tbody>
<tr>
    <th scope="row" style="width: 160px; ">Order No</th>
    <td>
     <span scope="row" style="width: 129px; "><c:out value="${hSMgtResultViewResult.salesOrdNo}"/></span>
    </td>
    <th scope="row" style="width: 117px; ">BS No</th>
    <td>
    <span style="width: 173px; "><c:out value="${hSMgtResultViewResult.no}"/></span>
    </td>
    <th scope="row" style="width: 117px; ">BS Month</th>
    <td>
    <span style="width: 173px; "><c:out value="${hSMgtResultViewResult.month}/${hSMgtResultViewResult.year}"/></span>
    </td>    
<tr>
    <th scope="row" style="width: 160px; ">Config Remark</th>
    <td colspan="5" style="width: 129px; ">
    <span ><c:out value="${hSMgtResultViewResult.c2}"/></span>
    </td> 
</tr>    
</tr>
</tbody>
</table>
<aside class="title_line mt20"><!-- title_line start -->
<h2>HS Result Information</h2>
</aside><!-- title_line end -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:120px" />
    <col style="width:130px" />
    <col style="width:140px" />
    <col style="width:130px" />
    <col style="width:140px" />
    <col style="width:140px" />       
</colgroup>
<tbody>
<tr>
    <th scope="row" style="width: 159px; ">Result No</th>
    <td style="width: 129px; ">
    <span><c:out value="${hSMgtResultViewResult.no1}"/></span>
    </td>
    <th scope="row" style="width: 117px; ">Result Status</th>
    <td style="width: 173px; ">
    <span><c:out value="${hSMgtResultViewResult.code}"/></span>
    </td>
    <th scope="row" style="width: 117px; ">Settle Date</th>
    <td style="width: 173px; ">
    <span><c:out value="${hSMgtResultViewResult.c1}"/></span>
    </td>    

</tr>
<tr>
    <th scope="row">Incharge Member</th>
    <td colspan="3" style="width: 420px; ">
    <span><c:out value="${hSMgtResultViewResult.memCode}- ${hSMgtResultViewResult.name}"/></span>
    </td>
    <th scope="row">Key By</th>
    <td>
    <span><c:out value="${hSMgtResultViewResult.userName}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Collection Code</th>
    <td colspan="3">
    <span><c:out value="${hSMgtResultViewResult.renColctDesc}"/></span>
    </td>
    <th scope="row">Key At</th>
    <td>
    <span><c:out value="${hSMgtResultViewResult.resultCrtDt}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Fail Reason</th>
    <td colspan="5">
        <span><c:out value="${hSMgtResultViewResult.failResnId}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Warehouse</th>
    <td colspan="5">
        <span><c:out value="${hSMgtResultViewResult.whLocCode}- ${hSMgtResultViewResult.whLocDesc}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="5">
        <span><c:out value="${hSMgtResultViewResult.resultRem}"/></span>
    </td>
</tr>
</tbody>
</table>

</form>
</section><!-- search_table end -->

<ul class="center_btns">
</ul>

</form>
<aside class="title_line mt20"><!-- title_line start -->
<h2>HS Result Filter Information</h2>
</aside><!-- title_line end -->
<article class="grid_wrap"><!-- grid_wrap start -->
      <div id="grid_wrap3" style="width: 100%; height: 130px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->
</section><!-- pop_body end -->


</div><!-- popup_wrap end -->
