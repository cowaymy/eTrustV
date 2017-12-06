<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript" language="javascript">


var  gridID;


$(document).ready(function(){
    
    //AUIGrid 그리드를 생성합니다.
    createAUIGrid();

    AUIGrid.bind(gridID, "cellDoubleClick", function(event) {
    	console.log(event.rowIndex);
           // fn_setDetail(listMyGridID, event.rowIndex);
    });
    
    f_multiCombo();
    fn_keyEvent();
    
});


function fn_keyEvent(){
	

    $("#sRVContrtNo").keydown(function(key)  {
            if (key.keyCode == 13) {
                fn_selectListAjax();
            }
     });
    
    $("#orderNo").keydown(function(key)  {
            if (key.keyCode == 13) {
                fn_selectListAjax();
            }
      });

    $("#creator").keydown(function(key)  {
            if (key.keyCode == 13) {
                fn_selectListAjax();
            }
      });
    
    $("#custId").keydown(function(key)  {
            if (key.keyCode == 13) {
                fn_selectListAjax();
            }
      });

    $("#custName").keydown(function(key)  {
        if (key.keyCode == 13) {
            fn_selectListAjax();
            }
      });
    
    $("#custNRIC").keydown(function(key)  {
        if (key.keyCode == 13) {
            fn_selectListAjax();
            }
      });
	
}

function fn_clear(){
	
	$("#sRVContrtNo").val("");
	$("#cmbStatus").val("");
	$("#salesDate").val("");
	$("#cmbSRVCStatus").val("");
	$("#orderNo").val("");
	$("#creator").val("");
	$("#custId").val("");
	$("#custName").val("");
	$("#custNRIC").val("");
}


// 리스트 조회.
function fn_selectListAjax() {        
	

   Common.ajax("GET", "/sales/membershipRental/selectList", $("#listSForm").serialize(), function(result) {
       
	   console.log(result);
       AUIGrid.setGridData(gridID, result);
   });
}




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
        
        var columnLayout = [
                            { dataField : "srvCntrctRefNo", headerText  : "Membership No.",    width : 100,  editable : false},
                            { dataField : "salesOrdNo", headerText  : "Order No.",width : 100,  editable: false },
                            { dataField : "code",   headerText  : "Status",  width          : 100,   editable       : false},
                            { dataField : "cntrctRentalStus", headerText  : "Rent Status",  width          : 100, editable       : false },
                            { dataField : "srvCntrctNetMonth",headerText  : "Net Mth",  width          : 100,   editable       : false},
                            { dataField : "srvCntrctNetYear",         headerText  : "Net Year",   width          : 100,     editable       : false },
                            { dataField : "srvPrdStartDt",       headerText  : "Start Date",  width          : 100, editable       : false,dataType : "date", formatString : "dd-mm-yyyy"},
                            { dataField : "srvCntrctPacDesc",     headerText  : "Package",  width          : 200,    editable       : false},
                            { dataField : "name",      headerText  : "Customer Name",   width          : 200,    editable       : false },
                            { dataField : "srvCntrctCrtDt",     headerText  : "Created",    width          : 100,        editable       : false,dataType : "date", formatString : "dd-mm-yyyy"},
                            { dataField : "userName",     headerText  : "Creator",    width : 100,       editable  : false}
                               
       ];

        var gridPros = { usePaging : true,  pageRowCount: 20, editable: false, fixedColumnCount : 1,selectionMode : "singleRow",  showRowNumColumn : true};  
        
        gridID = GridCommon.createAUIGrid("list_grid_wrap", columnLayout  ,"" ,gridPros);
    }
    
    

function  fn_goPayChannel(){


    var selectedItems = AUIGrid.getSelectedItems(gridID);
    
    if(selectedItems ==""){
       Common.alert("Membership Missing"+DEFAULT_DELIMITER+"No membership  selected. ");
       return ;
    }
    
     var pram  ="?srvCntrctId="+selectedItems[0].item.srvCntrctId+"&srvCntrctOrdId="+selectedItems[0].item.srvCntrctOrdId;
     Common.popupDiv("/sales/membershipRentalChannel/membershipRentalChannelPop.do"+pram ,null, null , true , '_PayChannelDiv1');
     
	
}

function fn_goRetPromo(){
	 alert('The program is under development');  
	 
}


function fn_goLEDGER(){
	

    var selectedItems = AUIGrid.getSelectedItems(gridID);
    
    if(selectedItems ==""){
        Common.alert("Membership Missing"+DEFAULT_DELIMITER+"No membership  selected. ");
        return ;
    }
    
     var pram  ="?srvCntrctId="+selectedItems[0].item.srvCntrctId+"&srvCntrctOrdId="+selectedItems[0].item.srvCntrctOrdId;
     Common.popupDiv("/sales/membershipRental/mRLedgerPop.do"+pram ,null, null , true , '_LedgerDiv1');
     
}

//Report
function fn_goKey_in_List(){
	Common.popupDiv("/sales/membershipRental/membershipKeyInListPop.do" ,null, null , true , '_rptDiv1');
}

function fn_goYSList(){
	 alert('The program is under development');  
}



function fn_goSVMDetails(){

	
	  var selectedItems = AUIGrid.getSelectedItems(gridID);
      
      if(selectedItems ==""){
          Common.alert("Membership Missing"+DEFAULT_DELIMITER+"No membership  selected. ");
          return ;
      }
      

      //contractID = this.RadGrid_SRVSales.SelectedValues["SrvContractID"].ToString();
      //Response.Redirect( "ServiceContract_Sales_View.aspx?ContractID=" + contractID);
      
      //$("#QUOT_ID").val(selectedItems[0].item.quotId);
      
      var pram  ="?srvCntrctId="+selectedItems[0].item.srvCntrctId; 
      Common.popupDiv("/sales/membershipRental/mRContSalesViewPop.do"+pram ,null, null , true , '_ViewSVMDetailsDiv1');
}


</script>






<section id="content"><!-- content start -->
<ul class="path">
	<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	<li>Sales</li>
	<li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Membership Management(Rental)</h2>
<ul class="right_btns">

    <li><p class="btn_blue"><a id="btnSrch" href="#" onClick="javascript:fn_goPayChannel();">Payment Channel</a></p></li>
    <li><p class="btn_blue"><a id="btnSrch" href="#" onClick="javascript:fn_goRetPromo();">Rental Promotion</a></p></li>
      
	<li><p class="btn_blue"><a href="#" onClick="javascript:fn_selectListAjax();" ><span class="search"></span>Search</a></p></li>
	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_clear();"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#"  id="listSForm" name="listSForm" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:180px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Membership No.</th>
	<td><input type="text" title="" placeholder="Rental Membership Number" class="w100p"   id="sRVContrtNo"  name="sRVContrtNo"/></td>
	<th scope="row">Membership Status</th>
	<td>
	       <select class="multy_select w100p" multiple="multiple"  id ="cmbStatus" name="cmbStatus"  >
                <option value="1" selected>Active</option>
                <option value="4" selected>Completed</option>
            </select>
			
	</td>
	<th scope="row">Sales Date</th>
	<td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p"   id="salesDate" name="salesDate" /></td>
</tr>
<tr>
	<th scope="row">Rental Status</th>
	<td>
			<select class="multy_select w100p" multiple="multiple"  id="cmbSRVCStatus"  name="cmbSRVCStatus">
                    <option value="ACT" selected>Active</option>
                    <option value="REG" selected>Regular</option>
                    <option value="INV" selected>Investigate</option>
                    <option value="SUS" selected>Suspend</option>
                    <option value="RET">Return</option>
                    <option value="TER">Terminate</option>
            </select>
		    
	</td>
	<th scope="row">Order No.</th>
	<td><input type="text" title="" placeholder="Order No" class="w100p"  id="orderNo" name="orderNo"/></td>
	<th scope="row">Creator</th>
	<td><input type="text" title="" placeholder="Creator" class="w100p"  id="creator" name="creator" /></td>
</tr>
<tr>
	<th scope="row">Customer ID</th>
	<td><input type="text" title="" placeholder="Customer ID (Numberic)" class="w100p"  id="custId"  name="custId"/></td>
	<th scope="row">Customer Name</th>
	<td><input type="text" title="" placeholder="Customer Name" class="w100p"  id="custName"  name="custName"/></td>
	<th scope="row">NRIC/Company No.</th>
	<td><input type="text" title="" placeholder="NRIC/Company No." class="w100p" id="custNRIC"  name="custNRIC"  /></td>
</tr>




</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
	<dt>Link</dt>
	<dd>
	<ul class="btns">
	
	</ul>
	<ul class="btns">
		<li><p class="link_btn type2"><a onclick="javascript:fn_goSVMDetails()" href="#">View Rental SVM Details</a></p></li>
		<li><p class="link_btn type2"><a onclick="javascript:fn_goLEDGER()" href="#">LEDGER</a></p></li>
		<li><p class="link_btn type2"><a onclick="javascript:fn_goKey_in_List()" href="#">Key-in List</a></p></li>
		<li><p class="link_btn type2"><a onclick="javascript:fn_goYSList()" href="#">YS List</a></p></li>
	</ul>
	<p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
	</dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
        <div id="list_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->


</div><!-- wrap end -->