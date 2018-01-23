<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

var boxGrid;

$(document).ready(function(){

    //AUIGrid 그리드를 생성합니다.
    creatBoxGrid();

    $("#radio2").hide();
    
});

function creatBoxGrid(){
    var boxLayout = [ 
         {dataField : "boxId", headerText : "Box ID", width : 150 , visible:false     },
         {dataField : "boxNo", headerText : "Box No", width : 180      },
         {dataField : "boxHolder", headerText : "Box Holder", width : 180       },
         {dataField : "boxBookQty", headerText : "Book in Box", width : 180        }       
         ];
   

   var boxOptions = {
              showStateColumn:false,
              showRowNumColumn    : true,
              usePaging : false,
              editable : false
        };    

   boxGrid = GridCommon.createAUIGrid("#boxGrid", boxLayout, "", boxOptions);
   
// 셀 클릭 이벤트 바인딩
   AUIGrid.bind(boxGrid, "cellClick", function(event){
       
	   $("#keepTrBoxId").val(AUIGrid.getCellValue(boxGrid , event.rowIndex , "boxId"));
            
   });
   
}

function fn_searchBox(val){
    if(val == 'E'){
        $("#radio1").show();
        $("#radio2").hide();
        $("#searchBox").val("E");
    }else if(val == 'N'){
        $("#radio1").hide();
        $("#radio2").show();
        $("#searchBox").val("N");
    }
}


function fn_KeepIntoBox(){
		
	if($("#searchBox").val() == 'E'){		
		if($("#keepTrBoxId").val() == ""){		
			Common.alert("Box Missing" +DEFAULT_DELIMITER+ "No TR box selected.");
		}else{
			
			Common.ajax("POST", "/sales/trBook/insertKeepIntoBox", $("#keepSaveForm").serializeJSON(), function(result)    {
		        
		        console.log("성공." + JSON.stringify(result));
		        console.log("data : " + result.cnt);

		        Common.alert("Save Successful" +DEFAULT_DELIMITER+ "TR book has successfully kept into box.");
		        $("#btnKeep").hide();
		        fn_selectListAjax();
		        
		     }
		     , function(jqXHR, textStatus, errorThrown){
		            try {
		                console.log("Fail Status : " + jqXHR.status);
		                console.log("code : "        + jqXHR.responseJSON.code);
		                console.log("message : "     + jqXHR.responseJSON.message);
		                console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
		          }
		          catch (e)
		          {
		            console.log(e);
		          }
		         
		          Common.alert("Failed To Save" +DEFAULT_DELIMITER+"Some unexpected error occurred in page.<br />Please try again later.");
		    });
			
		}
	}else{
		
		Common.ajax("POST", "/sales/trBook/insertKeepIntoNewBox", $("#keepSaveForm").serializeJSON(), function(result)    {
            
            console.log("성공." + JSON.stringify(result));
            console.log("data : " + result.data);

            $("#newBoxNo").text(result.data);
            
            Common.alert("Save Successful" +DEFAULT_DELIMITER+ "TR book has successfully kept into box.");
            fn_selectListAjax();
            $("#btnKeep").hide();
            
         }
         , function(jqXHR, textStatus, errorThrown){
                try {
                    console.log("Fail Status : " + jqXHR.status);
                    console.log("code : "        + jqXHR.responseJSON.code);
                    console.log("message : "     + jqXHR.responseJSON.message);
                    console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
              }
              catch (e)
              {
                console.log(e);
              }
              Common.alert("Failed To Save" +DEFAULT_DELIMITER+"Some unexpected error occurred in page.<br />Please try again later.");
        });
		
	}
}

function fn_searchBoxList(){
	var boxHolder = "${SESSION_INFO.code}";
	    
    Common.ajax("GET", "/sales/trBook/selelctBoxList", $("#keepSaveForm").serializeJSON(), function(result) {
      
       console.log("성공.");
       console.log( result);
       
      AUIGrid.setGridData(boxGrid, result);

      });
}

</script>
<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>TR BOOK - KEEP INTO BOX</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h2>TR Book Details</h2>
</aside><!-- title_line end -->

<form action="#" method="post" id="keepSaveForm" name ="keepSaveForm">

<input type="hidden" id="keepTrBookId" name="trBookId" value="${detailInfo.trBookId }" />
<input type="hidden" id="keepTrBoxId" name="trBoxId"  />
<input type="hidden" id="boxHolder" name="boxHolder"  value="${SESSION_INFO.code}"/>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:160px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">TR Book No</th>
	<td>${detailInfo.trBookNo }</td>
	<th scope="row">Prefix No</th>
	<td>${detailInfo.trBookPrefix }</td>
</tr>
<tr>
	<th scope="row">TR No</th>
	<td colspan="3">${detailInfo.trBookNoStart } To ${detailInfo.trBookNoEnd }</td>
</tr>
<tr>
	<th scope="row">Status</th>
	<td>${detailInfo.trBookStusCode }</td>
	<th scope="row">Total Page(s)</th>
	<td>${detailInfo.trBookPge }</td>
</tr>

</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Select TR Box</h2>
</aside><!-- title_line end -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Box Option</th>
    <td>
    <label><input type="radio" id="searchBox" name="searchBox" value="E" onclick="fn_searchBox('E')" checked="checked"/><span>Existing Box</span></label>
    <label><input type="radio" id="searchBox" name="searchBox" value="N" onclick="fn_searchBox('N')"/><span>New Box</span></label>
    </td>
</tr>

</tbody>
</table><!-- table end -->

<div id="radio1">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Box No</th>
    <td>
    <input type="text" title="" placeholder="Box No" class="w50p"  id="boxNo" name ="boxNo"/>
    <p class="btn_grid"><a href="#" onclick="javascript:fn_searchBoxList();"><span class="search"></span>Search</a></p>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<article class="grid_wrap"><!-- grid_wrap start -->
      <div id="boxGrid" style="width:100%; height:150px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
</div>

<div id="radio2">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Branch</th>
    <td>
    <span>${SESSION_INFO.code} - ${SESSION_INFO.branchName}</span>
    </td>
</tr>
<tr>
    <th scope="row">New Box No</th>
    <td>
    <span id="newBoxNo"></span>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</div>
</form>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id="btnKeep" onclick="fn_KeepIntoBox();">SAVE</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->