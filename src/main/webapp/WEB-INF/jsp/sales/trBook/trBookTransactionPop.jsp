<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script  type="text/javascript">
var trTranGrid;
var infoGrid;

$(document).ready(function(){  
	creatTrTranGrid();
	creatInfoGrid();
	//$("#tranInfoDiv").hide();
	
	$("#btnClear").on("click", function(){
		$("#tranForm")[0].reset();
	});
});


function creatTrTranGrid(){

    var trTranColLayout = [ 
          {dataField : "trBookId", headerText : "", width : 140  , visible:false   },
          {dataField : "trBookNo", headerText : "Book No", width : 140      },
          {dataField : "trBookPrefix", headerText : "Prefix", width : 110       },
          {dataField : "trBookNoStart", headerText : "SO No. From", width : 120        },
          {dataField : "trBookNoEnd", headerText : "SO No. To", width : 120        },
          {dataField : "trBookPge", headerText : "Total Sheet(s)", width : 130      },
          {dataField : "trBookStusCode", headerText : "Status", width : 110     },
          {dataField : "trHolder", headerText : "Holder User", width : 110       },
          {dataField : "trHolderType", headerText : "Holder Type", width : 110       } ,            
          {dataField : "boxNo", headerText : "Box No", width : 110       }             
          ];
    

    var trTranOptions = {
               showStateColumn:false,
               showRowNumColumn    : false,
               usePaging : true,
               editable : false,
               selectionMode : "singleRow"
         }; 
    
    trTranGrid = GridCommon.createAUIGrid("#trTranGrid", trTranColLayout, "", trTranOptions);
    
     // 셀 더블클릭 이벤트 바인딩
     AUIGrid.bind(trTranGrid, "cellDoubleClick", function(event){
         
    	 $("#trTranBookId").val(AUIGrid.getCellValue(trTranGrid, event.rowIndex, "trBookId"));
    	 
    	 fn_selectTransitInfoList();
    	 
     });
}

function creatInfoGrid(){

    var infoColLayout = [ 
          {dataField : "codeName", headerText : "Transit Type", width : 200  },
          {dataField : "trTrnsitFrom", headerText : "Transit From", width : 140      },
          {dataField : "trTrnsitTo", headerText : "Transit To", width : 140       },
          {dataField : "trTrnsitDt", headerText : "Date Assign", width : 140        },
          {dataField : "trTrnsitClosDt", headerText : "Date Close", width : 140        },
          {dataField : "curierName", headerText : "Courier", width : 180      }
          ];
    

    var infoOptions = {
               showStateColumn:false,
               showRowNumColumn    : false,
               usePaging : false,
               editable : false,
               selectionMode : "singleRow"
         }; 
    
    infoGrid = GridCommon.createAUIGrid("#infoGrid", infoColLayout, "", infoOptions);
    
}

//리스트 조회.
function fn_selectTrTranListAjax() {
    
  Common.ajax("GET", "/sales/trBook/selectTrBookMgmtList", $("#tranForm").serialize(), function(result) {
      
       console.log("성공.");
       console.log( result);
       
      AUIGrid.setGridData(trTranGrid, result);

  });
}

//TransitInfoList 조회.
function fn_selectTransitInfoList() {
    
  Common.ajax("GET", "/sales/trBook/selectTransitInfoList", $("#tranForm").serialize(), function(result) {
      
       console.log("성공.");
       console.log( result);
       
      AUIGrid.setGridData(infoGrid, result);

      //$("#tranInfoDiv").show();

  });
}

</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>TR Book Transaction</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto;"><!-- pop_body start -->

<form action="#" method="post" id="tranForm" name="tranForm">
<input type="hidden" id="pgm" name="pgm" value="tran"/>
<input type="hidden" id="trTranBookId" name="trBookId" />

<aside class="title_line"><!-- title_line start -->
<ul class="right_btns">
	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectTrTranListAjax();"><span class="search"></span>Search</a></p></li>
	<li><p class="btn_blue"><a href="#" id="btnClear"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->

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
	<th scope="row">Book No</th>
	<td><input type="text" title="" placeholder="Book No" class="w100p"  id="trTranBookNo" name ="trBookNo"/>
	<th scope="row">TR No</th>
	<td><input type="text" title="" placeholder="TR No" class="w100p" id="trTranNo" name="trNo"/>
	<th scope="row">Create Date</th>
	<td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="trTranBookCrtDt" name="trBookCrtDt"/>
</tr>
<tr>
	<th scope="row">Book Holder</th>
	<td><input type="text" title="" placeholder="Book Holder" class="w100p" id="trTranBookHolder" name="trBookHolder" />
	<th scope="row">Holder Type</th>
	<td>
		<select class="w100p" id="trTranHolderType" name="trHolderType">
            <option value="" selected="selected">Holder Type</option>
            <option value="Branch" >Branch</option>
            <option value="Member">Member</option>
        </select>
	</td>
	<td colspan="2"></td>
</tr>
</tbody>
</table><!-- table end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="trTranGrid" style="width:100%; height:250px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<div id="tranInfoDiv">
<aside class="title_line"><!-- title_line start -->
<h2>Transit Information</h2>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="infoGrid" style="width:100%; height:150px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->
</div>
</section><!-- search_result end -->


</section><!-- pop_body end -->

</div><!-- popup_wrap end -->