<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>



<script type="text/javaScript">

        //Combo Data
    var StatusTypeData = [{"codeId": "4","codeName": "Completed"},{"codeId": "21","codeName": "Failed"},{"codeId": "10","codeName": "Cancelled"}];
/*     cmbCollectType
    Collection Code */

  
    // AUIGrid 생성 후 반환 ID
    var myDetailGridID;   

    
        //close Func
    function fn_closeFunc(){
        alert(1111111);
    }
    
    var option = {
        width : "1000px", // 창 가로 크기
        height : "600px" // 창 세로 크기
    };
    
    function createAUIGrid(){
        // AUIGrid 칼럼 설정
        var columnLayout = [ {
                    dataField:"stkCode",
                    headerText:"Filter Code",
                    width:240,
                    height:30
                }, {                        
                    dataField : "stkId",
                    headerText : "Filter id",
                    width : 440
                }, {                        
                    dataField : "stkDesc",
                    headerText : "Filter Name",
                    width : 440
                }, {
                    dataField : "name",
                    headerText : "Filter Quantity",
                    width : 120,
                    dataType : "numeric",
			        renderer : {
			            type : "NumberStepRenderer",
			            min : 0,
			            max : 50,
			            step : 1,
			            textEditable : false
			        }                            
            }];
            // 그리드 속성 설정
            var gridPros = {
                // 페이징 사용       
                //usePaging : true,
                // 한 화면에 출력되는 행 개수 20(기본값:20)
                //pageRowCount : 20,
                
                editable : true,
                
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
                //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
                myDetailGridID = AUIGrid.create("#grid_wrap1", columnLayout, gridPros);
    }
    
    
    $(document).ready(function() {

    	   doDefCombo(StatusTypeData, '' ,'cmbStatusType', 'S', '');
 
           selSchdulId = $("#hidschdulId").val(); // TypeId 
           selSalesOrdId = $("#hidSalesOrdId").val(); // TypeId 
           openGb = $("#openGb").val(); // TypeId 

            //order detail
//           fn_getOrderDetailListAjax();
           
           createAUIGrid();
           fn_getHsFilterListAjax();
           
           
//           AUIGrid.setGridData(myGridID, "hsFilterList");                       
        //createAUIGridCust();
        //fn_getselectPopUpListAjax();
		
		
		
    });


    function fn_getHsFilterListAjax(){
         Common.ajax("GET", "/bs/SelectHsFilterList.do",{salesOrderId : '${hsDefaultInfo.salesOrdId}'}, function(result) {
            console.log("성공.");
            console.log("data : " + result);
            AUIGrid.setGridData(myDetailGridID, result);            
        }); 
    }   
    
    
    function fn_getOrderDetailListAjax(){
                   
           alert("selSalesOrdId:"+selSalesOrdId);
           
         //Common.ajax("GET", "/sales/order/orderDetailPop.do",{salesOrderId : '${hsDefaultInfo.salesOrdId}'}, function(result) {
         Common.ajax("GET", "/sales/order/orderDetailPop.do",{salesOrderId : 'selSalesOrdId'}, function(result) {
            console.log("성공.");
            console.log("data : " + result);
        }); 

    }                
        

    
    function fn_saveHsResult(){
        

/*              var dat =  GridCommon.getEditData(myGridID);
                  dat.form = $("#addHsForm").serializeJSON();
                
                 Common.ajax("POST", "/bs/addIHsResult.do",  dat.form, function(result) {
                    Common.alert(result.message.message);
                    console.log("성공.");
                    console.log("data : " + result);
            }); */


                     var jsonObj =  GridCommon.getEditData(myDetailGridID);
                    jsonObj.form = $("#addHsForm").serializeJSON();
              Common.ajax("POST", "/bs/addIHsResult.do", jsonObj, function(result) {

                console.log("성공.");
                console.log("data : " + result);
                Common.alert(result.message);
            });
        }
    
    
    
    </script>
    
    
    

<div id="popup_Editwrap" class="popup_wrap"><!-- popup_wrap start -->


 
<header class="pop_header"><!-- pop_header start -->

<h1>HS - Result Edit</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" onclick="fn_saveHsResult()">Save</a></p></li>
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form action="#" id="addHsForm" method="post">   
 <input type="hidden" value="${basicinfo.schdulId}" id="hidschdulId" name="hidschdulId"/>
 <input type="hidden" value="${basicinfo.salesOrdId}" id="hidSalesOrdId" name="hidSalesOrdId"/>
 
<aside class="title_line"><!-- title_line start -->
<h2>HS Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:90px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">HS No</th>
    <td><span><c:out value="${basicinfo.no}"/></span></td>
    <th scope="row">HS Month</th>
    <td><span><c:out value="${basicinfo.monthy}"/></span></td>
    <th scope="row">HS Type</th>
    <td><span><c:out value="${basicinfo.code}"/></span></td>    
</tr>
<tr>
    <th scope="row">Current BSR No</th>
    <td><span><c:out value="${basicinfo.c1}"/></span></td>
    <th scope="row"></th>
    <td><span></span></td>
    <th scope="row"></th>
    <td><span></span></td>
        
</tr>

</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Order Information</h2>
</aside><!-- title_line end -->
<!------------------------------------------------------------------------------
    Order Detail Page Include START
------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/jsp/sales/order/orderDetailContent.jsp" %>
<!------------------------------------------------------------------------------
    Order Detail Page Include END
------------------------------------------------------------------------------->
<aside class="title_line mt20"><!-- title_line start -->
<h2>HS Result Information</h2>
</aside><!-- title_line end -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">HS Status<span class="must">*</span></th>
    <td>
    <select class="w100p"  id ="cmbStatusType" name = "cmbStatusType">
    </select>
    </td>
    <th scope="row">Settle Date</th>
    <td><input type="text" id ="settleDate" name = "settleDate" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" value="${promoInfo.codeName}"/></td>
</tr>
<tr>
    <th scope="row">Fail Reason</th>
    <td>
    <select class="w100p" id ="failReason"  name ="failReason">

    </select>
    </td>
    <th scope="row">Collection Code<span class="must">*</span></th>
    <td>
    <select class="w100p"  id ="cmbCollectType" name = "cmbCollectType">
        <option value="" selected>Collection Code</option>
            <c:forEach var="list" items="${ cmbCollectTypeComboList}" varStatus="status">
                 <option value="${list.code}">${list.c1 } </option>
            </c:forEach>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Service Member</th>
    <td>
    <select class="w100p" id ="cmbServiceMem" name = "cmbServiceMem">
<!--         <option value="" selected>Service Member</option> 
            <c:forEach var="list" items="${ cmbServiceMemList}" varStatus="status">
                 <option value="${list.memCode}">${list.name } </option>
            </c:forEach>
            -->
            
    </select>
    </td>
    <th scope="row">Warehouse</th>
    <td>
    <select class="w100p" id ="wareHouse" name ="wareHouse">

    </select>
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td><textarea cols="20" rows="5" id ="remark" name = "remark"></textarea></td>
    <th scope="row">Instruction</th>
    <td><textarea cols="20" rows="5"id ="instruction" name = "instruction"></textarea></td>
</tr>
<tr>
    <th scope="row">Prefer Service Week</th>
    <td colspan="3">
    <label><input type="radio" name="srvBsWeek"  value="0"/><span>None</span></label>
    <label><input type="radio" name="srvBsWeek"  value="1"/><span>Week 1</span></label>
    <label><input type="radio" name="srvBsWeek"  value="2"/><span>Week 2</span></label>
    <label><input type="radio" name="srvBsWeek"  value="3"/><span>Week 3</span></label>
    <label><input type="radio" name="srvBsWeek"  value="4"/><span>Week 4</span></label>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Filter Information</h2>
</aside><!-- title_line end -->
<article class="grid_wrap"><!-- grid_wrap start -->
	 <div id="grid_wrap1" style="width: 100%; height: 334px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->
<ul class="center_btns">
    
<!--     <li><p class="btn_blue2 big"><a href="#" id="_close" onclick="javascript: fn_closeFunc()">Close</a></p></li> -->
<!--     <li><p class="btn_blue2 big"><a href="#">Close</a></p></li> -->
</ul>

</section><!-- pop_body end -->
</form>
</div><!-- popup_wrap end -->
