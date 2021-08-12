
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<script type="text/javascript">

var membershipQuotInfoFilterGridID; // membershipQuotInfoFilterGridID list


$(document).ready(function(){  
    createFilterGrid();  
    fn_resize();
    
    if($("#QUOT_ID").val() !=""){
    	 fn_getMembershipQuotInfoFilterAjax();
    }
});


function createFilterGrid(){
    
    var membershipQuotInfoFilterLayout = [
         {dataField : "stkCode",headerText : "Code", width : 100},
         {dataField : "stkDesc", headerText : "Description", width : 280},
         {dataField : "stkPriod", headerText : "Change Period", width :100},
         {dataField : "stkFilterPrc", headerText : "Filter Price", width :100},
         {dataField : "stkChrgPrc", headerText : "Charge Price", width :100},
         {dataField : "stkLastChngDt", headerText : "Last Change Date",width :120 ,dataType : "date", formatString : "dd-mm-yyyy" }

         ];
    
    membershipQuotInfoFilterGridID = GridCommon.createAUIGrid("#filter_grid_wrap", membershipQuotInfoFilterLayout,''); 
}



function fn_getMembershipQuotInfoAjax (){
      Common.ajax("GET", "/sales/membership/selectMembershipQuotInfo",{QUOT_ID:$("#QUOT_ID").val() }, function(result) {
         console.log(result);
      
         try{
        	    $("#quotNo").html(result[0].quotNo);
                $("#crtDt").html(result[0].crtDt);
                $("#crtUserId").html(result[0].crtUserId);
         }catch(e){ }
          
      });
}



function fn_getMembershipQuotInfoFilterAjax (_QUOT_ID){
		
	  var v_QUOT_ID = $("#QUOT_ID").val();
	  
	  if(_QUOT_ID !="" && _QUOT_ID != undefined){
		   v_QUOT_ID = _QUOT_ID;
	  }
	  
      Common.ajax("GET", "/sales/membership/selectMembershipQuotFilter",{QUOT_ID:v_QUOT_ID }, function(result) {
         console.log(result);
         AUIGrid.setGridData(membershipQuotInfoFilterGridID, result);
      });
}


function fn_resize(){
	AUIGrid.resize(membershipQuotInfoFilterGridID, 1000,300)
}
</script>



<article class="tap_area"><!-- tap_area start -->
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="filter_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>  
    </article><!-- grid_wrap end -->
</article><!-- tap_area end -->