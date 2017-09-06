<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
//AUIGrid 그리드 객체
var myPopGridID;


//AUIGrid 칼럼 설정
var myPopLayout = [   
    { dataField:"billItmType" ,headerText:"Bill Type",width: 200 , editable : false},
    { dataField:"billItmRefNo" ,headerText:"Order Number",width: 200 , editable : false},
    { dataField:"memoItmChrg" ,headerText:"Amount", editable : false, dataType : "numeric",formatString : "#,##0.00" ,width : 120},
    { dataField:"memoItmTxs" ,headerText:"GST", editable : false ,dataType : "numeric",formatString : "#,##0.00" ,width : 120},
    { dataField:"memoItmAmt" ,headerText:"Total", editable : false, dataType : "numeric",formatString : "#,##0.00" ,width : 120}
    
    ];
    
//화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){    
    
    //Grid Properties 설정 
    var gridPros = {            
            editable : false,                 // 편집 가능 여부 (기본값 : false)
            showStateColumn : false,     // 상태 칼럼 사용
            height : 200
    };
    
    // Order 정보 (Master Grid) 그리드 생성
    myPopGridID = GridCommon.createAUIGrid("grid_Pop_wrap", myPopLayout,null,gridPros);
    
    //초기화면 로딩시 조회    
    selectAdjustmentDetailPop("${adjId}");
   
});


function selectAdjustmentDetailPop(adjId){
    
    //데이터 조회 (초기화면시 로딩시 조회)       
    Common.ajax("GET", "/payment/selectAdjustmentDetailPop.do", {"adjId":adjId}, function(result) {
        if(result != 'undefined'){
           
            //Master데이터 출력
            $("#tRequestor").text(result.master.memoAdjCrtUserId);
            $("#tStatus").text(result.master.memoAdjStusNm);
            $("#tDept").text(result.master.deptName);
            $("#tRefNo").text(result.master.memoAdjRefNo);
            $("#tReportNo").text(result.master.memoAdjRptNo);
            $("#tType").text(result.master.memoAdjTypeNm);
            $("#tReason").text(result.master.resnDesc);            
            $("#tInvoiceNo").text(result.master.taxInvcRefNo);
            $("#tInvoiceDt").text(result.master.taxInvcRefDt);
            $("#tGrpNo").text(result.master.taxInvcGrpNo);
            $("#tOrderNo").text(result.master.ordNo);
            $("#tMemoRemark").text(result.master.memoAdjRem);
            $("#tCustNmt").text(result.master.taxInvcCustName);
            $("#tContactPerson").text(result.master.taxInvcCntcPerson);
            $("#tAddr").text(result.master.address);
            $("#tInvoiceRemark").text(result.master.taxInvcRem);
            
            
            

            //Detail데이터 출력
            AUIGrid.setGridData(myPopGridID, result.detailList);

            
        }
    });
}


</script>
<!-- popup_wrap start -->
<div id="popup_wrap" class="popup_wrap">
    <!-- pop_header start -->
    <header class="pop_header">
        <h1>Credit Note / Debit Note</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" id="_close1">CLOSE</a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->
    <!-- getParams  -->
    <section class="pop_body">
        <!-- pop_body start -->
        <form id="_invoicePopForm"> <!-- Form Start  -->
            <aside class="title_line mt0">
                <h3>Adjustment Information</h3>
            </aside>
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:150px" />
                    <col style="width:*" />
                    <col style="width:150px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Requestor ID</th>
                        <td id="tRequestor">
                            
                        </td>
                        <th scope="row">Adjustment Status</th>
                        <td id="tStatus">
                            
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Department</th>
                        <td colspan="3" id="tDept">
                            
                        </td>
                    </tr>
                    
                    <tr>
                        <th scope="row">Memo Ref No.</th>
                        <td id="tRefNo">
                        
                        </td>
                        <th scope="row">Report No.</th>
                        <td id="tReportNo">
                        
                        </td>
                    </tr>
                    
                    <tr>
                        <th scope="row">Memo Type</th>
                        <td id="tType">
                        
                        </td>
                        <th scope="row">Memo Reason</th>
                        <td id="tReason">
                        
                        </td>
                    </tr>
                    
                    <tr>
                        <th scope="row">Invoice No</th>
                        <td id="tInvoiceNo">
                        
                        </td>
                        <th scope="row">Invoice Date</th>
                        <td id="tInvoiceDt">
                        
                        </td>
                    </tr>
                    
                    <tr>
                        <th scope="row">Group No.</th>
                        <td id="tGrpNo">
                        
                        </td>
                        <th scope="row">Order No.</th>
                        <td id="tOrderNo">
                        
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Memo Remark</th>
                        <td colspan="3"  id="tMemoRemark">
                        
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Customer Name</th>
                        <td colspan="3"  id="tCustNmt">
                        
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Contact Person</th>
                        <td colspan="3"  id="tContactPerson">
                        
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Address</th>
                        <td colspan="3"  id="tAddr">
                        
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Remark</th>
                        <td colspan="3"  id="tInvoiceRemark">
                        
                        </td>
                    </tr>                                     
                </tbody>
            </table>
            <!-- table end -->
        </form>
        <!--Form End  -->
        
        <!-- search_result start -->
        <aside class="title_line mt0">
            <h3>Item(s) Information</h3>
        </aside>
        <section class="search_result">
            <!-- grid_wrap start -->
            <article id="grid_Pop_wrap" class="grid_wrap"></article>
            <!-- grid_wrap end -->
        </section>
        <!-- search_result end -->

        <ul class="center_btns">
            <li><p class="btn_blue2"><a href="javascript:fn_getInvoiceListAjax();" id="_saveBtn">Search</a></p></li>
        </ul>

    </section><!-- pop_body end -->
</div>