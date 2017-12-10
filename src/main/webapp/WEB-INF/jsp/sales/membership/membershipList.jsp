<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript" language="javascript">
	
	//AUIGrid 생성 후 반환 ID
	var  gridID;

	
	$(document).ready(function(){
		
        //AUIGrid 그리드를 생성합니다.
        createAUIGrid();

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(gridID, "cellDoubleClick", function(event) {
        	   // fn_setDetail(listMyGridID, event.rowIndex);
        	   
        	$("#ORD_ID").val(event.item.ordId);
            $("#MBRSH_ID").val(event.item.mbrshId);
        	 Common.popupDiv("/sales/membership/selMembershipView.do", {ORD_ID :event.item.ordId ,MBRSH_ID: event.item.mbrshId } );
        });
        
        f_multiCombo();
        
        fn_keyEvent();
    });

	
	
	
	 // 리스트 조회.
    function fn_selectListAjax() {        
        Common.ajax("GET", "/sales/membership/selectMembershipList", $("#listSForm").serialize(), function(result) {
        	
        	 console.log("성공.");
             console.log( result);
             
            AUIGrid.setGridData(gridID, result);
        });
    }

	 
    // 조회조건 combo box
    function f_multiCombo(){
        $(function() {
            $('#MBRSH_STUS_ID').change(function() {
            
            }).multipleSelect({
                selectAll: true, // 전체선택 
                width: '80%'
            });
            $('#MBRSH_STUS_ID').multipleSelect("checkAll");
        });
    }
  
    
 
  
    
	
	
	function createAUIGrid() {
	        
	        //AUIGrid 칼럼 설정
	        var columnLayout = [
	                            {     dataField     : "mbrshNo",                 
	                            	   headerText  : "Membership No",  
	                            	   width          : 150,               
	                            	   editable       : false,    
	                            	   style           : 'left_style'
	                            }, 
	                            {     dataField     : "mbrshOtstnd",          
	                            	   headerText  : "Outstanding",           
	                            	   width          : 150,                
	                            	   editable       : false,     
	                            	   style           : 'left_style'
	                            }, 
	                            {     dataField     : "ordNo",                     
	                            	   headerText  : "Order No",           
	                            	   width          : 150,                 
	                            	   editable       : false,     
	                            	   style           : 'left_style'
	                            }, 
	                            {      dataField     : "custName",                
	                            	    headerText  : "Customer Name",           
	                            	    width          : 150,                 
	                            	    editable       : false,     
	                            	    style           : 'left_style'
	                            }, 
	                            {      dataField       : "mbrshStusCode",      
	                            	    headerText   : "Status",           
	                            	    width           : 150,                 
	                            	    editable        : false,     
	                            	    style            : 'left_style'
	                             }, 
	                            {      dataField   : "mbrshStartDt",        
	                            	   headerText  : "Start Date",          
	                            	   width       : 150,                 
	                            	   editable    : false,     
	                            	   style           : 'left_style',
	                            	   dataType : "date", formatString : "dd/mm/yyyy"
	                            }, 
	                            {      dataField   : "mbrshExprDt",          
	                            	   headerText  : "Expire Date",           
	                            	   width       : 150,                 
	                            	   editable    : false,     
	                            	   style           : 'left_style',
	                            	   dataType : "date", formatString : "dd/mm/yyyy"
	                            }, 
	                            {      dataField   : "pacName",                  
	                            	   headerText  : "Package",           
	                            	   width       : 150,                 
	                            	   editable    : false,     
	                            	   style           : 'left_style'
	                            }, 
	                            {      dataField   : "mbrshDur",                
	                            	   headerText  : "Duration (Mth)",           
	                            	   width       : 150,                 
	                            	   editable    : false,     
	                            	   style           : 'left_style'
	                            }, 
	                            {      dataField   : "mbrshCrtDt",           
	                            	    headerText  : "Create Date",           
	                            	    width       : 150,                 
	                            	    editable    : false,     
	                            	    style           : 'left_style',
	                            	    	dataType : "date", formatString : "dd/mm/yyyy"
	                            }, 
	                            {      dataField   : "mbrshCrtUserId",   
			                            headerText  : "Creator",           
			                            width       : 150,                 
			                            editable    : false,     
			                            style           : 'left_style'
	                            },
	                            {
	                                dataField : "mbrshId",
	                                visible : false
	                                   },
                                 {
                                     dataField : "ordId",
                                     visible : false
                                        }
	                            
	       ];

	        //그리드 속성 설정
	        var gridPros = {
	            usePaging           : true,             //페이징 사용
	            pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
	            editable                : false,            
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
	        
	        gridID = GridCommon.createAUIGrid("list_grid_wrap", columnLayout, "", gridPros);
	    }
	
	
	
	  function fn_clear(){
	     
	  }
	  
	  
	  
	  function fn_doViewLegder(){
		   
		  var selectedItems = AUIGrid.getSelectedItems(gridID);
		  
		  if(selectedItems.length <= 0) {
		      Common.alert(" No membership  selected. ");
			  return;  
		  }
		  Common.popupDiv("/sales/membership/selMembershipViewLeader.do?MBRSH_ID="+selectedItems[0].item.mbrshId);
	  }
	  
	  
	  
	  function  fn_doMFree(){
		    var _option = {   width : "1200px",  height : "800px"   };
	        
		    var selectedItems = AUIGrid.getSelectedItems(gridID);
		    
		    if(selectedItems.length <= 0) {
	              Common.alert(" No membership  selected. ");
	              return;  
	          }
		    
		    
		    Common.popupWin("listSForm", "/sales/membership/membershipFreePop.do?MBRSH_ID="+selectedItems[0].item.mbrshId, _option);
	  }
	  
	  
	  
	  
	  function  fn_doMOutSPay(){
		  
          var selectedItems = AUIGrid.getSelectedItems(gridID);
          
          if(selectedItems ==""){
        	  Common.alert("No membership selected..");
        	  return ;
          }
          
	      var v_mbrshOtstnd =selectedItems[0].item.mbrshOtstnd;
	          
	      if (parseInt(v_mbrshOtstnd,10) <= 0) {
	    	  Common.alert("<b>[" + selectedItems[0].item.mbrshNo+ "] does not has any outstanding.<br />Payment is not necessary.</b>");
	    	  return ;
	      }
          
          var pram  ="?MBRSH_ID="+selectedItems[0].item.mbrshId+"&ORD_ID="+selectedItems[0].item.ordId;
          Common.popupDiv("/sales/membership/membershipPayment.do"+pram);
    }
    
	  
	  
	function fn_report(type) {
		
		  var selectedItems = AUIGrid.getSelectedItems(gridID);
		  
		  if(type=="Invoice"){
			  if (parseInt(selectedItems[0].item.mbrshId ,10) < 490447){
				  // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
		            var option = {
		                isProcedure : false // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
		            };
				  
				  
				  $("#V_REFNO").val(selectedItems[0].item.mbrshId);
		            Common.report("reportInvoiceForm", option);
		            
			  }else{
				  Common.alert("<b>[" + selectedItems[0].item.mbrshId+ "]  does not  has event [490447]</b>");
				  return ;
			  }
		  }

	      
	}
    

	

function fn_keyEvent(){
    

    $("#MBRSH_NO").keydown(function(key)  {
            if (key.keyCode == 13) {
            	fn_selectListAjax();
            }
     });
}
function fn_clear(){
	$("#MBRSH_NO").val("");
	$("#ORD_NO").val("");
	$("#MBRSH_CRT_DT").val("");
	$("#MBRSH_CRT_USER_ID").val("");
	$("#MBRSH_OTSTND").val("");
}

	

</script>


<form id="popForm" method="post">
    <input type="hidden" name="ORD_ID"  id="ORD_ID"/>  
    <input type="hidden" name="MBRSH_ID"   id="MBRSH_ID"/>
</form>

<form id="reportInvoiceForm" method="post">

    <input type="hidden" id="reportFileName" name="reportFileName" value="/membership/MembershipInvoice.rpt" />
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    <input type="hidden" id="V_REFNO" name="V_REFNO"  value=""/>
  
        
</form>


<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	<li>Sales</li>
	<li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Membership Management(Outright) </h2>
<ul class="right_btns">
      <c:if test="${PAGE_AUTH.funcUserDefine5 == 'Y'}">
               <li><p class="btn_blue"><a id="btnSrch" href="#" onClick="javascript:fn_doMOutSPay();">Outstanding Payment</a></p></li>
     </c:if>
     
    <li><p class="btn_blue"><a id="btnSrch" href="#" onClick="javascript:fn_doMFree();">Free Membership</a></p></li>
    <li><p class="btn_blue"><a id="btnSrch" href="#" onClick="javascript:fn_selectListAjax();"><span class="search"></span>Search</a></p></li>
	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_clear()"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#"  id="listSForm" name="listSForm" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:170px" />
	<col style="width:*" />
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:170px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Membership No</th>
	<td>
	   <input type="text" title="" id="MBRSH_NO" name="MBRSH_NO"placeholder="Membership Number" class="w100p" />
	</td>
	<th scope="row">Order No</th>
	<td>
	<input type="text" title=""  id="ORD_NO"  name="ORD_NO" placeholder="Order Number" class="w100p" />
	</td>
	<th scope="row">Create Date</th>
	<td>
	<input type="text" title="Create start Date"   id="MBRSH_CRT_DT" name="MBRSH_CRT_DT" placeholder="DD/MM/YYYY" class="j_date w100p" />
	</td>
</tr>
<tr>
	<th scope="row">Create By</th>
	<td>
	<input type="text" title=""  id="MBRSH_CRT_USER_ID"  name="MBRSH_CRT_USER_ID" placeholder="Creator" class="w100p" />
	</td>
	<th scope="row">Status</th>
	<td>
    <select id="MBRSH_STUS_ID" name="MBRSH_STUS_ID" class="multy_select w100p" multiple="multiple" >
        <option value="1">Active</option>
        <option value="4">Completed</option>
    </select>
	</td>
	<th scope="row">Outstanding</th>
	<td>
	 <select class="w100p"  id="MBRSH_OTSTND" name="MBRSH_OTSTND" >
	    <option value=""> </option>
        <option value="1">With Outstanding</option>
        <option value="2">Without Outstanding</option>
        <option value="3">Over Paid</option>
    </select>
	</td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
	<dt>Link</dt>
	<dd>

	<ul class="btns">
		<li><p class="link_btn type2"><a href="#" onclick="javascript: fn_doViewLegder()"> LEDGER</a></p></li>
		<li><p class="link_btn type2"><a href="#" onclick="javascript: fn_report('Invoice')">Invoice</a></p></li>
		<li><p class="link_btn type2"><a href="#" onclick="javascript: alert('The program is under development')" >Key-in List</a></p></li>
		<li><p class="link_btn type2"><a href="#" onclick="javascript: alert('The program is under development')">YS List</a></p></li>
	</ul>
	<p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
	</dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
	<li><p class="btn_grid"><a href="#" onclick="javascript: alert('The program is under development')">Expire List</a></p></li>
	<li><p class="btn_grid"><a href="#" onclick="javascript: alert('The program is under development')">Expire List (Only Rental)</a></p></li>
	
</ul> 

<article class="grid_wrap"><!-- grid_wrap start -->
            <div id="list_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

