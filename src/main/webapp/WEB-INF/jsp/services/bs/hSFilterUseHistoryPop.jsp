<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

    var myDetailGridIDInActive;

    function createAUIGridInactive(){
        // AUIGrid 칼럼 설정
        var columnLayout = [ 
										
                                        {                        
                                            dataField : "resultType",
                                            //headerText : "Type",
                                            headerText : '<spring:message code="service.grid.Type" />',
                                            width : 120 
                                        },
                                        {                        
                                            dataField : "resultYear",
                                            //headerText : "Year",
                                            headerText : '<spring:message code="service.grid.Year" />',
                                            width : 120 
                                        },
                                        {                        
                                            dataField : "resultMonth",
                                            //headerText : "Month",
                                            headerText : '<spring:message code="service.grid.Month" />',
                                            width : 120 
                                        },
                                        {                        
                                            dataField : "resultEntryNo",
                                            //headerText : "AS/BS No",
                                            headerText : '<spring:message code="service.grid.AS_BSNo" />',
                                            width : 120 
                                        },
                                        {                        
                                            dataField : "resultNo",
                                            //headerText : "Result No",
                                            headerText : '<spring:message code="service.grid.ResultNo" />',
                                            width : 120 
                                        },
                                        {                        
                                            dataField : "setlDt",
                                            //headerText : "Settle Data",
                                            headerText : '<spring:message code="service.grid.SettleData" />',
                                            width : 120,
                                            dataType : "date",
                                            formatString : "dd/mm/yyyy"   
                                        },
                                        {                        
                                            dataField : "filterName",
                                            //headerText : "Name",
                                            headerText : '<spring:message code="service.grid.Name" />',
                                            width : 120 
                                        },
                                        {                        
                                            dataField : "filterQty",
                                            //headerText : "Qty",
                                            headerText : '<spring:message code="service.grid.Qty" />',
                                            width : 120 
                                        },
                                        {                        
                                            dataField : "filterStusCode",
                                            //headerText : "Status",
                                            headerText : '<spring:message code="service.grid.Status" />',
                                            width : 120 
                                        },
                                        {                        
                                            dataField : "filterPeriod",
                                            //headerText : "Period",
                                            headerText : '<spring:message code="service.grid.Period" />',
                                            width : 120 
                                        } 
                                   ];
            // 그리드 속성 설정
            var gridPros = {
                // 페이징 사용       
                //usePaging : true,
                // 한 화면에 출력되는 행 개수 20(기본값:20)
                //pageRowCount : 20,
                
                editable : false,
                
                //showStateColumn : true, 
                
                //displayTreeOpen : true,
                
                headerHeight : 30,
                
                // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                skipReadonlyColumns : true,
                
                // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                wrapSelectionMove : true,
                
                // 줄번호 칼럼 렌더러 출력
                showRowNumColumn : true
        
            };
            myDetailGridIDInActive = AUIGrid.create("#grid_wrap_useHistory", columnLayout, gridPros);
    }
    
        function fn_getUseHistoryInfo(){
            
            Common.ajax("GET", "/services/bs/hSFilterUseHistory.do", {OrderID : $("#orderId").val() ,StockID :  $("#stkId").val() }, function(result) {
                console.log("fn_getUseHistoryInfo.");
                console.log(  JSON.stringify(result));
                AUIGrid.setGridData(myDetailGridIDInActive, result);        
            });
            
        }
        
        $(document).ready(function() {
            createAUIGridInactive();
            
            fn_getUseHistoryInfo();
            
        });

        
        
    function fn_close() {
        $("#popClose").click();
    }       

</script>


<body>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="service.title.orderFilterUseHistory" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form action="#" method="post"  id='orderInfoForm'  name='orderInfoForm' >
    <input type="hidden" name="SRV_FILTER_ID"  id="SRV_FILTER_ID" value=""/>  
    <input type="hidden" name="orderId"  id="orderId" value="${orderId}"/>
    <input type="hidden" name="stkId"  id="stkId" value="${stkId}"/>
    

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="service.title.InactiveFilterList" /></h2>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap_useHistory" style="width: 100%; height: 134px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

  
</form>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</body>