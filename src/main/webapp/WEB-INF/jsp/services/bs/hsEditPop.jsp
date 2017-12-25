<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>



<script type="text/javaScript">

        //Combo Data
    var StatusTypeData2 = [{"codeId": "4","codeName": "Completed"},{"codeId": "21","codeName": "Failed"},{"codeId": "10","codeName": "Cancelled"}];
/*     cmbCollectType
    Collection Code */

  
    // AUIGrid 생성 후 반환 ID
    var myDetailGridID;   
    var myDetailGridID2;   
    var myDetailGridID3;   

    

    
    var option = {
        width : "1000px", // 창 가로 크기
        height : "600px" // 창 세로 크기
    };
    
    

    function createAUIGrid(){
        // AUIGrid 칼럼 설정
        var columnLayout = [ {
                    dataField:"stkCode",
                    headerText:"Filter Code",
                    width:200,
                    height:30
                }, {                        
                    dataField : "stkId",
                    headerText : "Filter id",
                    width : 140,
                    visible:false   
                }, {                        
                    dataField : "stkDesc",
                    headerText : "Filter Name",
                    width : 440              
                    }, {
                    dataField : "bsResultItmId",
                    headerText : "Filter Name",
                    width : 240    ,
                    visible:false                       
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
    
    
    


    function createAUIGrid2(){
        // AUIGrid 칼럼 설정
        var resultColumnLayout = [ {
                    dataField:"stkCode",
                    headerText:"Version",
                    width:200,
                    height:30
                }, {                        
                    dataField : "no1",
                    headerText : "BSR No",
                    width : 140
                }, {                        
                    dataField : "code",
                    headerText : "Status",
                    width : 440              
                }, {
                    dataField : "memCode",
                    headerText : "Member",
                    width : 240  
                }, {
                    dataField : "c1",
                    headerText : "Settle Date",
                    width : 240 ,
                    dataType : "date", 
                    formatString : "dd/mm/yyyy"                  
                }, {
                    dataField : "bsResultItmId",
                    headerText : "Has Filter",
                    width : 240                      
                }, {
                    dataField : "bsResultItmId",
                    headerText : "Key At",
                    width : 240                   
                }, {
                    dataField : "bsResultItmId",
                    headerText : "Key By",
                    width : 240                        
                }, {
                    dataField : "bsResultItmId",
                    headerText : "View",
                    width : 240    
            }];
            
            // 그리드 속성 설정
            var gridPros = {
                usePaging           : true,         //페이징 사용
                pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
                editable            : false,            
                fixedColumnCount    : 1,            
                showStateColumn     : true,             
                displayTreeOpen     : false,            
                selectionMode       : "singleRow",  //"multipleCells",            
                headerHeight        : 30,       
                useGroupingPanel    : false,        //그룹핑 패널 사용
                skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
                noDataMessage       : "No order found.",
                groupingMessage     : "Here groupping"
        
            };
                //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
                myDetailGridID2 = GridCommon.createAUIGrid("hsResult_grid_wrap", resultColumnLayout,'', gridPros);
    }
    




    function createAUIGrid3(){
        // AUIGrid 칼럼 설정
        var fitercolumnLayout = [ {
                    dataField:"no",
                    headerText:"BSR No",
                    width:200,
                    height:30
                }, {                        
                    dataField : "stkDesc",
                    headerText : "Filter",
                    width : 140
                }, {                        
                    dataField : "bsResultPartQty",
                    headerText : "Qty",
                    width : 90              
                }, {
                    dataField : "bsResultFilterClm",
                    headerText : "Claim",
                    width : 240    ,
                    visible:false                       
               }, {
                    dataField : "resultCrtDt",
                    headerText : "Key At",
                    width : 240        ,
                    visible:false                    
               }, {
                    dataField : "userName",
                    headerText : "Key By",
                    width : 240       ,
                    visible:false                    

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
                myDetailGridID3 = GridCommon.createAUIGrid("fiter_grid_wrap", fitercolumnLayout, '',gridPros);
    }

    
                    
    
    $(document).ready(function() {

    	   doDefCombo(StatusTypeData2, '' ,'cmbStatusType2', 'S', '');
            
            
            
           selSchdulId = $("#hidschdulId").val(); // TypeId 
           selSalesOrdId = $("#hidSalesOrdId").val(); // TypeId 
           openGb = $("#openGb").val(); // TypeId 
           brnchId = $("#brnchId").val(); // TypeId  
           hidHsno = $("#hidHsno").val(); // TypeId  
           hrResultId = $("#hrResultId").val(); // TypeId  
           
             
           createAUIGrid();
           createAUIGrid2();
           createAUIGrid3();
          
           fn_getHsViewfilterInfoAjax();
           
           var statusCd = "${basicinfo.stusCodeId}";
           $("#cmbStatusType2 option[value='"+ statusCd +"']").attr("selected", true);

            var failResnCd = "${basicinfo.failResnId}";
            if(failResnCd != "0" ){
                $("#failReason option[value='"+failResnCd +"']").attr("selected", true);
            }else{
            	$("#failReason").find("option").remove();
            }
      
           var codyIdCd = "${basicinfo.codyId}";
           $("#cmbServiceMem option[value='"+codyIdCd +"']").attr("selected", true);

           var renColctCd = "${basicinfo.renColctId}";
           $("#cmbCollectType option[value='"+renColctCd +"']").attr("selected", true);

             if($("#_openGb").val() == "view"){
                    $("#btnSave").hide();
            }                 
    
             
             
            if('${MOD}' =="VIEW"){
               $("#stitle").text("HS - Result View")	;
               $("#addHsForm").find("input, textarea, button, select").attr("disabled",true);
               
               
            }else {
                $("#stitle").text("HS - Result EDIT")  ;
                
                if($("#stusCode").val()==4) {
                    $("#addHsForm").find("input, textarea, button, select").attr("disabled",true);
                    $('#cmbCollectType').removeAttr('disabled'); 
                }
                
            }
    
    });


    function fn_getHsViewfilterInfoAjax(){
    	 Common.ajax("GET", "/services/bs/selectHsViewfilterPop.do",{selSchdulId : selSchdulId}, function(result) {
             console.log("성공 fn_getHsViewfilterInfoAjax.");
             console.log("data : " + result);
             AUIGrid.setGridData(myDetailGridID, result);            
         }); 
        


          Common.ajax("GET", "/services/bs/selectHistoryHSResult.do",{hrResultId : hrResultId}, function(result) {
            console.log("성공 selectHistoryHSResult.");
            console.log("data : " + result);
            AUIGrid.setGridData(myDetailGridID2, result);            
        }); 


         Common.ajax("GET", "/services/bs/selectFilterTransaction.do",{selSchdulId : selSchdulId}, function(result) {
            console.log("성공 selectFilterTransaction.");
            console.log("data : " + result);
            AUIGrid.setGridData(myDetailGridID3, result);            
        }); 
    
        
        
        
    }   
    
    
    
    function fn_getOrderDetailListAjax(){
                   
         Common.ajax("GET", "/sales/order/orderDetailPop.do",{salesOrderId : 'selSalesOrdId'}, function(result) {
            console.log("성공.");
            console.log("data : " + result);
        }); 

    }                
        

    
     function fn_UpdateHsResult(){
     
    	     $("#cmbCollectType1").val(addHsForm.cmbCollectType.value);
              var jsonObj =  GridCommon.getEditData(myDetailGridID);
                    jsonObj.form = $("#editHSResultForm").serializeJSON();
              Common.ajax("POST", "/services/bs/UpdateHsResult2.do", jsonObj, function(result) {
              Common.alert(result.message, fn_parentReload);

            });
        }
    
    
    function fn_parentReload() {
        fn_getBSListAjax(); //parent Method (Reload)
    }    
      
        //resize func (tab click)
    function fn_resizefunc(obj, gridName){ //

         var $this = $(obj);
         var width = $this.width();


          AUIGrid.resize(gridName, width, 200);
//          AUIGrid.resize(gridName, width, height);

//         setTimeout(function(){
//             AUIGrid.resize(gridName);
//         }, 100);
    }    
    </script>
    
    
    

<div id="popup_Editwrap" class="popup_wrap"><!-- popup_wrap start -->


 
<header class="pop_header"><!-- pop_header start -->

<h1>  <spin id='stitle'>  </spin></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"  id="btnSave" name="btnSave" onclick="fn_UpdateHsResult()">SAVE</a></p></li>
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form action="#" id="addHsForm" method="post">   
 
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
    <td colspan="3"><span><c:out value="${basicinfo.codeName}"/></span></td>    
</tr>
<tr>
    <th scope="row">Current BSR No</th>
    <td><span><c:out value="${basicinfo.c1}"/></span></td>
    <th scope="row">Prev HS Area</th>
    <td><span><c:out value="${basicinfo.prevSvcArea}"/></span></td>
    <th scope="row">Next HS Area</th>
    <td><span><c:out value="${basicinfo.nextSvcArea}"/></span></td>
     <th scope="row">Distance</th>
    <td><span><c:out value="${basicinfo.distance}"/></span></td>
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


<article class="acodi_wrap"><!-- acodi_wrap start -->
<dl>
    <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc(this, myDetailGridID2)">Current & History HS Result</a></dt>
    <dd>
        <article class="grid_wrap"><!-- grid_wrap start -->
             <div id="hsResult_grid_wrap" style="width:100%; height:210px; margin:0 auto;"></div>             
        </article><!-- grid_wrap end -->
    </dd>
    <dt class="click_add_on"><a href="#" onclick="javascript: fn_resizefunc(this, myDetailGridID3)">Filter Transaction</a></dt>
    <dd>
        <article class="grid_wrap"><!-- grid_wrap start -->
         <div id="fiter_grid_wrap" style="width: 100%; height: 210px; margin: 0 auto;"></div>
        </article><!-- grid_wrap end -->
    </dd>
</dl>
</article><!-- acodi_wrap end -->


<aside class="title_line mt20"><!-- title_line start -->
<h2>HS Result Information</h2>
</aside><!-- title_line end -->
<table class="type1" style="width: 1040px; "><!-- table start -->
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
    <select class="w100p"  id ="cmbStatusType2" name = "cmbStatusType2"></select>
    </td>
    <th scope="row" style="width: 186px; ">Settle Date</th>
    <td><span><c:out value="${basicinfo.setlDt}"/></span> </td>
</tr>
<tr>
    <th scope="row">Fail Reason</th>
    <td>
    <select class="w100p" id ="failReason"  name ="failReason">
       <c:forEach var="list" items="${failReasonList}" varStatus="status">
             <option value="${list.codeId}">${list.codeName } </option>
        </c:forEach>
    </select>
    </td>
    <th scope="row" style="width: 244px; ">Collection Code<span class="must">*</span></th>
    <td>
    <select class="w100p"  id ="cmbCollectType" name = "cmbCollectType">
            <c:forEach var="list" items="${ cmbCollectTypeComboList}" varStatus="status">
                 <option value="${list.code}">${list.c1 } </option>
            </c:forEach>
    </select>
    </td>
</tr>
<%-- <tr>
    <th scope="row">Service Member</th>
    <td>
    <select class="w100p" id ="cmbServiceMem" name = "cmbServiceMem">
       <c:forEach var="list" items="${ serMemList}" varStatus="status">
            <option value="${list.codeId}">${list.codeName } </option>
       </c:forEach>
    </select>
    </td>
    <th scope="row">Warehouse</th>
    <td>
    <select class="w100p" id ="wareHouse" name ="wareHouse">

    </select>
    </td>
</tr> --%>
<tr>
    <th scope="row" style="width: 176px; ">Remark</th>
    <td><span>${basicinfo.resultRem}</span></td>
    <th scope="row" style="width: 59px; ">Instruction</th>
    <td><span>${settleInfo.configBsRem}</span></td>
</tr>
<tr>
    <th scope="row">Prefer Service Week</th>
    <td colspan="1">
    <label><input type="radio" name="srvBsWeek" <c:if test="${basicinfo.srvBsWeek == 0 || orderDetail.orderCfgInfo.configBsWeek > 4}">checked</c:if> disabled/><span>None</span></label>
    <label><input type="radio" name="srvBsWeek" <c:if test="${basicinfo.srvBsWeek == 1}">checked</c:if> /><span>Week1</span></label>
    <label><input type="radio" name="srvBsWeek" <c:if test="${basicinfo.srvBsWeek == 2}">checked</c:if> /><span>Week2</span></label>
    <label><input type="radio" name="srvBsWeek" <c:if test="${basicinfo.srvBsWeek == 3}">checked</c:if> /><span>Week3</span></label>
    <label><input type="radio" name="srvBsWeek" <c:if test="${basicinfo.srvBsWeek == 4}">checked</c:if> /><span>Week4</span></label>

 <%--    <label><input type="radio" name="srvBsWeek" <c:if test="${basicinfo.srvBsWeek == 4}">checked</c:if> disabled/><span>Week4</span></label> --%>
    </td> 
        <th scope="row" style="width: 186px; ">Cancel Request Number</th>
    <td>
        <span><c:out value="${basicinfo.cancReqNo}"/></span> 
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
</form>
<form id="editHSResultForm" method="post" action="#">


 <div  style="display:none">

 <input type="text" value="${basicinfo.schdulId}" id="hidschdulId" name="hidschdulId"/>
 <input type="text" value="${basicinfo.salesOrdId}" id="hidSalesOrdId" name="hidSalesOrdId"/>
 <input type="text" value="${basicinfo.no}" id="hidHsno" name="hidHsno"/>
 <input type="text" value="${basicinfo.c2}" id="hrResultId" name="hrResultId"/>
 <input type="text" value="${basicinfo.srvBsWeek}" id="srvBsWeek" name="srvBsWeek"/>
 <input type="text" value="${basicinfo.codyId}" id="cmbServiceMem" name="cmbServiceMem"/>

   
 <input type="text" value="<c:out value="${basicinfo.stusCodeId}"/> "  id="stusCode" name="stusCode"/>
 <input type="text" value="<c:out value="${basicinfo.failResnId}"/> "  id="failResn" name="failResn"/>
 <input type="text" value="<c:out value="${basicinfo.renColctid}"/> "  id="renColct" name="renColct"/>
 <input type="text" value="<c:out value="${basicinfo.codyId}"/> "  id="codyId" name="codyId"/>
 <input type="text" value="<c:out value="${basicinfo.setlDt}"/> "  id="setlDt" name="setlDt"/>
 <input type="text" value="<c:out value="${basicinfo.configBsRem}"/> "  id="configBsRem" name="configBsRem"/>
 <input type="text" value="<c:out value="${basicinfo.configBsRem}"/> "  id="Instruction" name="Instruction"/>
 <input type="text" value=""  id="cmbCollectType1" name="cmbCollectType"/>
 
 </div>
 
</form>
</section><!-- pop_body end -->
</div><!-- popup_wrap end -->
