<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">
    
    //AUIGrid 생성 후 반환 ID
    var  gridID;
    var  quotationList;
    
    $(document).ready(function(){
        
        if('${quotationList}'=='' || '${quotationList}' == null){
        }else{
        	quotationList = JSON.parse('${quotationList}');      
        	console.log(quotationList);
        }   

        createAUIGrid();       
    });
       
   
   function createAUIGrid() {
           var columnLayout = [ 
                     {dataField :"quotNo",  headerText : "Quotation No",      width: 100 ,editable : false },
                     {dataField :"ordNo",  headerText : "Order No",    width: 80, editable : false },
                     {dataField :"custName", headerText : "Customer Name",   width: 140, editable : false },
                     {dataField :"validStus", headerText : "Status",  width: 60, editable : false },
                     /* {dataField :"hasbill", headerText : "HasBill" , width: 60, editable : false ,
                         renderer : {
                             type : "CheckBoxEditRenderer",
                             editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
                             checkValue : "1"  
                         }
                     }, */
                     {dataField :"validDt", headerText : "Valid Date",width: 90, dataType : "date", formatString : "dd-mm-yyyy"  ,editable : false },
                     {dataField :"pacDesc", headerText : "Package", width: 160, editable : false },
                     {dataField :"dur", headerText : "Duration</br>(Mth)",width: 75, editable : false },
                     {dataField :"crtDt", headerText : "Create Date", width: 90,  dataType : "date", formatString : "dd-mm-yyyy" ,editable : false},
                     {dataField :"crtUserId", headerText : "Creator" , width: 120, editable : false }
                    
          ];

           //그리드 속성 설정
         var gridPros = { usePaging : true,  pageRowCount: 20, editable: false, fixedColumnCount : 1,             
                 headerHeight        : 30,       showRowNumColumn : true};  
           
           gridID = GridCommon.createAUIGrid("list_grid_wrap", columnLayout, "" ,gridPros);
           
           if(quotationList != '' ){
               AUIGrid.setGridData(gridID, quotationList);
           } 
       }

 </script>
 
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>Order Outrigth Membership Quotation Listing </h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"  id="pcl_close">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body win_popup"  ><!-- pop_body start -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="list_grid_wrap" style="width:100%; height:360px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

