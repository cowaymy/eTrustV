



<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

var  payGridID;

$(document).ready(function(){
	
	 doGetCombo('/common/selectCodeList.do', '1', '','MEM_TYPE', 'S' , '');  
	
	   //AUIGrid 그리드를 생성합니다.
      createAUIGrid();
	
       //j_date
        var pickerOpts={
                changeMonth:true,
                changeYear:true,
                dateFormat: "dd/mm/yy"
        };
        
        $(".j_date").datepicker(pickerOpts);
        

        $("#MEM_CODE").keydown(function(key)  {
                if (key.keyCode == 13) {
                	fn_getPaymentCollecterList();
                }
         });
        
        $("#MEM_NAME").keydown(function(key)  {
            if (key.keyCode == 13) {
                fn_getPaymentCollecterList();
            }
     });
        
        $("#NRIC").keydown(function(key)  {
            if (key.keyCode == 13) {
                fn_getPaymentCollecterList();
            }
     });
        
        

    AUIGrid.bind(payGridID, "cellDoubleClick", function(event) {
            console.log(event);
               // fn_setDetail(listMyGridID, event.rowIndex);
               
            if('${resultFun}' == 'C'){
                fn_doCollecterResult(event.item);
            } else if('${resultFun}' == 'S'){
                fn_doSalesResult(event.item);
            }
            $("#pcl_close").click();
    });
        
        
});



function createAUIGrid(){
    
    var cLayout = [
	         {dataField : "codeName",headerText : "<spring:message code="sal.title.type" />", width : 100},
	         {dataField : "memCode", headerText : "<spring:message code="sal.title.code" />", width : 100},
	         {dataField : "name", headerText : "<spring:message code="sal.title.name" />", width :300},
	         {dataField : "nric", headerText : "<spring:message code="sal.title.nric" />", width :100},
	         {dataField : "c1", headerText : "<spring:message code="sal.title.joinDate" />", width :140},
	         {
                 dataField : "undefined",
                 headerText : " ",
                 width           : 110,    
                 renderer : {
                     type : "ButtonRenderer",
                     labelText : "<spring:message code="sal.title.select" />",
                     onclick : function(rowIndex, columnIndex, value, item) {
                    	 
                    	 if('${resultFun}' == 'C'){
                             fn_doCollecterResult(item);
                    	 } else if('${resultFun}' == 'S'){
                    		 fn_doSalesResult(item);
                    	 }
                    	 
                    	 $("#pcl_close").click();
                     }
                 }
             },
            {
                  dataField : "memId",
                  visible : false
               }
   ];
    
    payGridID = GridCommon.createAUIGrid("#c_grid_wrap", cLayout,''); 
}



function fn_getPaymentCollecterList (){ 
	Common.ajax("GET", "/sales/membership/paymentCollecterList", $("#sParamForm").serialize(), function(result) {
		     console.log( result);
		     AUIGrid.setGridData(payGridID, result);
	});
}


function fn_doClear(){
	
	$("#MEM_CODE").val("");
	$("#JOIN_DATE").val("");
	$("#MEM_TYPE").val("");
	$("#NRIC").val("");
	$("#MEM_NAME").val("");
	
}

</script>



<form id="sParamForm" name="sParamForm">


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.collecctorSearch" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"  id="pcl_close"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

<ul class="right_btns mb10">
	<li><p class="btn_blue"><a href="#"  onclick="javascript:fn_getPaymentCollecterList()"><span class="search" ></span><spring:message code="sal.btn.search" /></a></p></li>
	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_doClear()"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:160px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="sal.text.memtype" /></th>
	<td>
	<select class="w100p"  id="MEM_TYPE"  name="MEM_TYPE">
	</select>
	</td>
	<th scope="row"><spring:message code="sal.text.memberCode" /></th>
	<td><input type="text" title="" placeholder="" class="w100p" id="MEM_CODE"   name="MEM_CODE"/></td>
	<th scope="row"><spring:message code="sal.text.joinDate" /></th>
	<td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY"   id="JOIN_DATE"   name="JOIN_DATE" class="j_date w100p" /></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.memberName" /></th>
	<td colspan="3"><input type="text" title="" placeholder="" class="w100p"  id="MEM_NAME"   name="MEM_NAME"  /></td>
	<th scope="row"><spring:message code="sal.text.nric" /></th>
	<td><input type="text" title="" placeholder="" class="w100p"  id="NRIC"   name="NRIC" /></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result mt30"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
        <div id="c_grid_wrap" style="width:900; height:400px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
</form>
