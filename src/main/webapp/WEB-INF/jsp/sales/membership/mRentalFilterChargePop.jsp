
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>



<script type="text/javaScript" language="javascript">
    
    //AUIGrid 생성 후 반환 ID
    var  gridFilterID;
    
    
    // 리스트 조회.
   function fn_filterSelectListAjax() {
       Common.ajax("GET", "/sales/membershipRentalQut/getFilterChargeList.do",{
    	   SALES_ORD_NO : $("#ORD_NO_P").val(),
           ORD_ID : $("#ORD_ID").val(),
    	   PROMO_ID: $('#cPromo').val() ,
    	   SRV_PAC_ID :$('#cTPackage').val() 
       }, function(result) {
            console.log( result);
            AUIGrid.setGridData(gridFilterID, result);
            
            
            var idx = AUIGrid.getRowCount(gridFilterID);
            
            for(var i = 0; i < idx ; i++){
                
                var amt = AUIGrid.getCellValue(gridFilterID, i, "prc");
                
                if($("#zeroRatYn").val() == "N" || $("#eurCertYn").val() == "N"){                 
                    AUIGrid.setCellValue(gridFilterID, i, "prc", Math.floor(amt * 100 / 106))  
                }
                
            }
            
       });
   }
    
    
    
   

   function createFAUIGrid() {
	   

	    
/* 	   var columnLayout = [ 
	                       {dataField :"bomCompnt",  headerText : "Code",      width: 150 ,editable : false },
	                       {dataField :"bomCompntDesc",  headerText : "Descrption",    width: 250, editable : false },
	                       {dataField :"srvFilterPriod", headerText : "LifePeriod",   width: 150, editable : false },
	                       {dataField :"srvFilterPrvChgDt", headerText : "LastChangeDate", dataType : "date", formatString : "dd-mm-yyyy"  ,editable : false},
	                       {dataField :"amt", headerText : "OriPrice",width: 100 ,editable : false , dataType:"numeric", formatString : "#,##0.00"},
	                       {dataField :"disamt", headerText : "ChargePrice", width: 100, editable : false  , dataType:"numeric", formatString : "#,##0.00"}
	   ]; */
	   var columnLayout = [ 
                           {dataField :"filterCode",  headerText : "Code",      width: 150 ,editable : false },
                           {dataField :"filterDesc",  headerText : "Descrption",    width: 250, editable : false },
                           {dataField :"lifePriod", headerText : "LifePeriod",   width: 150, editable : false },
                           {dataField :"lastChngDt", headerText : "LastChangeDate", dataType : "date", formatString : "dd-mm-yyyy"  ,editable : false},
                           {dataField :"oriPrc", headerText : "OriPrice",width: 100 ,editable : false , dataType:"numeric", formatString : "#,##0.00"},
                           {dataField :"prc", headerText : "ChargePrice", width: 100, editable : false  , dataType:"numeric", formatString : "#,##0.00"}
       ];      

	   

	   
	   //그리드 속성 설정
	    var gridPros = {           
	        usePaging           : true,             //페이징 사용
	        pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)           
	        editable                : false,            
	        fixedColumnCount    : 1,      
	       // selectionMode       : "singleRow",  //"multipleCells",    
	        showRowNumColumn    : true  ,
	        showFooter : true  ,
            showStateColumn :false
	    };

	    
	    //푸터 설정
        var footerObject = [ 
                                {
                                    labelText : "COUNT :",
                                    positionField : "filterDesc"
                                },
                              {
                                   dataField : "lifePriod",
                                   positionField : "lifePriod",
                                   operation : "COUNT",
                                   formatString : "#,##0"
                              },
                              {
                                  labelText : "Total :",
                                  positionField : "oriPrc"
                             },
                              {
                                  dataField : "prc",
                                  positionField : "prc",
                                  operation : "SUM",
                                  formatString : "#,##0.00"
                              }
            ];
	     
	     gridFilterID = GridCommon.createAUIGrid("gridFilterID_list_grid_wrap", columnLayout, "", gridPros);
         AUIGrid.setFooter(gridFilterID, footerObject); 
        
        
       }
   
   
   
   

  function fn_close(){
       $("#_editDiv1").remove();
       $("#_popupDiv").remove();
  }

    
  </script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>FILTER CHARGE DETAILS-NO PROMOTION</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"   onclick="javascript:fn_close()">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_result mt30"><!-- search_result start -->


<article class="grid_wrap"><!-- grid_wrap start -->
<div id="gridFilterID_list_grid_wrap" style="width:100%; height:400px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

<script> 

$(document).ready(function(){
    
     createFAUIGrid();
     fn_filterSelectListAjax() ;
     

     
});


</script>