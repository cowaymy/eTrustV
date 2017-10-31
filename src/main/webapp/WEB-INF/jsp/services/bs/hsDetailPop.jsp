<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>



<script type="text/javaScript">

        //Combo Data
    var StatusTypeData1 = [{"codeId": "4","codeName": "Completed"},{"codeId": "21","codeName": "Failed"},{"codeId": "10","codeName": "Cancelled"}];
/*     cmbCollectType
    Collection Code */

  
    // AUIGrid 생성 후 반환 ID
    var myDetailGridID;   

    
    var option = {
        width : "1000px", // 창 가로 크기
        height : "600px" // 창 세로 크기
    };
    
    
         function fn_close(){
         $("#popup_wrap").remove();
     }
     
    function createAUIGrid(){
        // AUIGrid 칼럼 설정
        var columnLayout = [ {
                    dataField:"stkCode",
                    headerText:"Filter Code",
                    width:140,
                    height:30
                }, {                        
                    dataField : "stkId",
                    headerText : "Filter id",
                    width : 240
                }, {                        
                    dataField : "stkDesc",
                    headerText : "Filter Name",
                    width : 240
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
                //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
                myDetailGridID = AUIGrid.create("#grid_wrap1", columnLayout, gridPros);
    }
    
    
    $(document).ready(function() {

    	   doDefCombo(StatusTypeData1, '' ,'cmbStatusType1', 'S', '');
            //order detail
           fn_getOrderDetailListAjax();

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
        
         Common.ajax("GET", "/sales/order/orderDetailPop.do",{salesOrderId : '${hsDefaultInfo.salesOrdId}'}, function(result) {
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

//111

            
           if("" == $("#settleDate").val() || null == $("#settleDate").val()){
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='settleDate Type'/>");
                return false;
            }
            
            if("" == $("#remark").val() || null == $("#remark").val()){
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='remark Type'/>");
                return false;
            }            


            if("" == $("#instruction").val() || null == $("#instruction").val()){
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='instruction Type'/>");
                return false;
            }  
            
            
/*             if("" == $("#srvBsWeek").val() || null == $("#srvBsWeek").val()){
                Common.alert("<spring:message code='sys.common.alert.validation' arguments='Week Type'/>");
                return false;
            }  */
                        
            
            
             var jsonObj =  GridCommon.getEditData(myDetailGridID);
                    jsonObj.form = $("#addHsForm").serializeJSON();
              Common.ajax("POST", "/bs/addIHsResult.do", jsonObj, function(result) {
              //Common.alert(result.message.message);
                console.log("message : " + result.message );
                
                Common.alert(result.message,fn_close);

            });
        }
        
        
    function fn_close(){
        $("#popup_wrap").remove();
         fn_parentReload();
    }
    
    function fn_parentReload() {
        fn_getBSListAjax(); //parent Method (Reload)
    }    
    
    
        var StatusTypeData1 = [{"codeId": "4","codeName": "Completed"},{"codeId": "21","codeName": "Failed"},{"codeId": "10","codeName": "Cancelled"}];

    function onChangeStatusType(val){

        if($("#cmbStatusType1").val() == '4'){
        
          $("select[name=failReason]").attr('disabled', 'disabled');
          //$("select[name=cmbCollectType]").attr("disabled ",true);
          $("select[name=cmbCollectType]").attr('disabled',false);

            /* $("select[name=cmbCorpTypeId]").removeClass("w100p disabled");
            $("select[name=cmbCorpTypeId]").addClass("w100p");
            $("#cmbCorpTypeId").val('1173');
            $("#cmbNation").val('');
            $("select[name=cmbNation]").addClass("w100p disabled");
            $("select[name=cmbNation]").attr('disabled', 'disabled');
            $("#cmbRace").val('');
            $("select[name=cmbRace]").addClass("w100p disabled");
            $("select[name=cmbRace]").attr('disabled', 'disabled');
            $("#dob").val('');
//            $("select[name=dob]").attr('readonly','readonly');
            $("#dob").attr({'disabled' : 'disabled' , 'class' : 'j_date3 w100p'}); 
            $("#genderForm").attr('disabled',true);
            $("input:radio[name='gender']:radio[value='M']").prop("checked", false);
            $("input:radio[name='gender']:radio[value='F']").prop("checked", false);
            $("input:radio[name='gender']").attr("disabled" , "disabled");
            $("#genderForm").attr('checked', false); */
        }else if ($("#cmbStatusType1").val() == '21') {

            $("select[name=cmbCollectType]").attr('disabled', 'disabled');
           // $("select[name=failReason]").attr("enabled",true);
            $("select[name=failReason]").attr('disabled',false);
        }
        
    }
            
    
    </script>
    
    
    

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<form action="#" id="addHsForm" method="post">   
 <input type="hidden" value="${hsDefaultInfo.schdulId}" id="hidschdulId" name="hidschdulId"/>
 <input type="hidden" value="${hsDefaultInfo.salesOrdId}" id="hidSalesOrdId" name="hidSalesOrdId"/>
 <input type="hidden" value="${hsDefaultInfo.codyId}" id="hidCodyId" name="hidCodyId"/>
 <input type="hidden" value="${hsDefaultInfo.no}" id="hidSalesOrdCd" name="hidSalesOrdCd"/>
<header class="pop_header"><!-- pop_header start -->

<h1>HS - New HS Result</h1>
<ul class="right_opt">
    <li><p class="btn_blue2 big"><a href="#" onclick="fn_saveHsResult()">Save</a></p></li>
    <li><p class="btn_blue2 big"><a href="#" onclick="fn_close()">Close</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

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
    <td><span><c:out value="${hsDefaultInfo.no}"/></span></td>
    <th scope="row">HS Month</th>
    <td><span><c:out value="${hsDefaultInfo.monthy}"/></span></td>
    <th scope="row">HS Type</th>
    <td><span><c:out value="${hsDefaultInfo.codeName}"/></span></td>    
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
    <select class="w100p"  id ="cmbStatusType1" name = "cmbStatusType"  onchange="onChangeStatusType(this.value)"" >
    </select>
    </td>
    <th scope="row">Settle Date<span class="must">*</span></th>
    <td><input type="text" id ="settleDate" name = "settleDate" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" /></td>
</tr>
<tr>
    <th scope="row">Fail Reason</th>
    <td>
    <select class="w100p" id ="failReason"  name ="failReason">
        <option value="" selected>Choose One</option>
            <c:forEach var="list" items="${failReasonList}" varStatus="status">
                 <option value="${list.codeId}">${list.codeName } </option>
            </c:forEach>
    </select>
    </td>
    <th scope="row">Collection Code<span class="must">*</span></th>
    <td>
    <select class="w100p"  id ="cmbCollectType" name = "cmbCollectType">
        <option value="" selected>Choose One</option>
            <c:forEach var="list" items="${ cmbCollectTypeComboList}" varStatus="status">
                 <option value="${list.code}">${list.c1 } </option>
            </c:forEach>
    </select>
    </td>
</tr>
<tr>
<%--     <th scope="row">Service Member</th>
    <td>
    <select class="w100p" id ="serMemList" name = "serMemList">
         <option value="" selected>Choose One</option> 
            <c:forEach var="list" items="${ serMemList}" varStatus="status">
                 <option value="${list.CodeId}">${list.codeName } </option>
            </c:forEach>
    </select>
    </td>
    <th scope="row">Warehouse</th>
    <td>
    <select class="w100p" id ="wareHouse" name ="wareHouse" >

    </select>
    </td>
</tr>
<tr> --%>
    <th scope="row">Remark<span class="must">*</span></th>
    <td><textarea cols="20" rows="5" id ="remark" name = "remark"></textarea></td>
    <th scope="row">Instruction<span class="must">*</span></th>
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
	 
<!-- 	 <ul class="center_btns">
	    <li><p class="btn_blue2 big"><a href="#" onclick="fn_saveHsResult()">Save</a></p></li>
	    <li><p class="btn_blue2 big"><a href="#">Close</a></p></li>
    </ul> -->
</article><!-- grid_wrap end -->



</section><!-- pop_body end -->
</form>
</div><!-- popup_wrap end -->
