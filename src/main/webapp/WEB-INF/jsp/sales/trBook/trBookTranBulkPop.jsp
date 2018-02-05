<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">
var tranGridID;
var tranToGridID;


$(document).ready(function(){      
       CommonCombo.make("branchFrom", "/sales/trBook/selectBranch", {"branchId" : "${branchId}"}, "${branchCode}", {
            id: "code",
            name: "name"
        }, fn_selectTranListAjax);
        
       CommonCombo.make("branchTo", "/sales/trBook/selectBranch", "", "", {
            id: "code",
            name: "name"
        });
        
        CommonCombo.make("tBulkCourier", "/sales/trBook/selectCourier", "", "", {
            id: "curierCode",
            name: "curierName"
        });
    
        creatTranGrid();

        $("#branchFrom").on("change", fn_selectTranListAjax);
        
       // fn_selectTranListAjax();
});


function creatTranGrid(){

    var tranColLayout = [ 
          {dataField : "trBookId", headerText : "", width : 140  , visible:false  ,
        	  filter : {
        		  showIcon : true
        		  }, 
          },
          {dataField : "trBookNo", headerText : '<spring:message code="sal.text.bookNo" />', width : 140      ,
              filter : {
                  showIcon : true
                  }, 
           },
          {dataField : "trBookPrefix", headerText : '<spring:message code="sal.text.prefixNo" />', width : 110       ,
              filter : {
                  showIcon : true
                  }, 
           },
          {dataField : "trBookNoStart", headerText : '<spring:message code="sal.title.text.trNoStart" />', width : 120         ,
               filter : {
                   showIcon : true
                   }, 
            },
          {dataField : "trBookNoEnd", headerText : '<spring:message code="sal.title.text.trNoEnd" />', width : 120         ,
                filter : {
                    showIcon : true
                    }, 
             },
          {dataField : "trBookPge", headerText : '<spring:message code="sal.title.sheet" />', width : 130     ,
              filter : {
                  showIcon : true
                  }, 
           },
          {dataField : "trBookStusCode", headerText : '<spring:message code="sal.title.status" />', width : 110     },
          {dataField : "trHolder", headerText : '<spring:message code="sal.title.text.holder" />', width : 110       },
          {dataField : "trHolderType", headerText : '<spring:message code="sal.title.text.holderType" />', width : 110       }             
          ];
    
    var tranToColLayout = [ 
          {dataField : "trBookId", headerText : "", width : 140  , visible:false            },
          {dataField : "trBookNo", headerText : '<spring:message code="sal.title.bookNo" />', width : 140                 },
          {dataField : "trBookPrefix", headerText : '<spring:message code="sal.text.prefixNo" />', width : 110                },
          {dataField : "trBookNoStart", headerText : '<spring:message code="sal.title.text.trNoStart" />', width : 120        },
          {dataField : "trBookNoEnd", headerText : '<spring:message code="sal.title.text.trNoEnd" />', width : 120        },
          {dataField : "trBookPge", headerText : '<spring:message code="sal.title.sheet" />', width : 130              },
          {dataField : "trBookStusCode", headerText : '<spring:message code="sal.title.status" />', width : 110     },
          {dataField : "trHolder", headerText : '<spring:message code="sal.title.text.holder" />', width : 110       },
          {dataField : "trHolderType", headerText : '<spring:message code="sal.title.text.holderType" />', width : 110       }             
          ];
    

    var tranOptions = {
               showStateColumn:false,
               showRowNumColumn    : false,
               usePaging : false,
               editable : false,
               fixedColumnCount    : 2,
               //selectionMode : "multiRow",
               softRemoveRowMode:false
         }; 
    
    tranGridID = GridCommon.createAUIGrid("#tranGridID", tranColLayout, "", tranOptions);
    tranToGridID = GridCommon.createAUIGrid("#tranToGridID", tranToColLayout, "", tranOptions);
 
     
}

var fromItems = new Array();
var idx = 0;

function fn_holdDataMove(){

    var delCnt=0;
	var selectItems = AUIGrid.getSelectedItems(tranGridID);
	
    console.log(selectItems);
       
    
    for (var i in selectItems) {
    	//var value = test[i];
        fromItems[idx] = AUIGrid.getItemByRowIndex(tranGridID, selectItems[i].rowIndex-delCnt);

        //AUIGrid.removeRow(tranGridID, selectItems[i].rowIndex);

        AUIGrid.removeRow(tranGridID, selectItems[i].rowIndex-delCnt);
        delCnt++;
        idx++;
    }	
    
    console.log(fromItems);
    
    AUIGrid.setGridData(tranToGridID, fromItems);
    
}

function fn_tranDataMove(){

	var delCnt=0;
	var selectItems = AUIGrid.getSelectedItems(tranToGridID);
	
    for (var i in selectItems) {
    	
        var rowIdx = selectItems[i].rowIndex;
                
        AUIGrid.addRow(tranGridID, selectItems[i].item, 'first');   
                
        fromItems.splice(rowIdx-delCnt, 1);
                
        console.log("add Item" + selectItems[i]);   
                
        AUIGrid.removeRow(tranToGridID, rowIdx-delCnt);
        delCnt++;
        idx--;
    }	    
    
}


//리스트 조회.
function fn_selectTranListAjax() {
    
  Common.ajax("GET", "/sales/trBook/selectTrBookTranList", $("#tranBForm").serialize(), function(result) {
      
       console.log("성공.");
       console.log( result);
       
      AUIGrid.setGridData(tranGridID, result);
      AUIGrid.clearGridData(tranToGridID);

  });
}


function fn_tranBulkSave(){
    
     if ($("#branchFrom").val() == "" ||$("#branchTo").val() == "" || $("#tBulkCourier").val() == "")
     {
    	 Common.alert('<spring:message code="sal.alert.msg.reqFieldEmpty" />' + DEFAULT_DELIMITER + '<spring:message code="sal.alert.msg.somReqFielddEmpty" />');
         return false;
     }
     
     if($("#branchFrom").val() == $("#branchTo").val()){
         Common.alert('<spring:message code="sal.alert.msg.trbookInformation" />' + DEFAULT_DELIMITER + '<spring:message code="sal.alert.msg.cannotTrsferTrBooktoSameBrnch" />');
         return false;
     }
     
     if(AUIGrid.getRowCount(tranToGridID) < 1){

         Common.alert('<spring:message code="sal.alert.msg.trbookInformation" />' + DEFAULT_DELIMITER + '<spring:message code="sal.alert.msg.noBookTrsFerPlzAddBook" />');
         return false;
     }
     
     var data = $("#tranBForm").serializeJSON();    
     var gridData = AUIGrid.getGridData(tranToGridID);
     data.gridData = gridData;
     
     Common.ajax("POST", "/sales/trBook/saveTranBulk", data, function(result) {
         
         console.log("성공.");
         console.log( result);        


         Common.alert('<spring:message code="sal.aerlt.msg.saveSuccessful" />' + DEFAULT_DELIMITER + '<spring:message code="sal.alert.msg.selTrBookSuccessTrsferToCourier" />' + result.data );
         $("#btnTranBulkSave").hide();
         
         fromItems = new Array();
         idx = 0;
         
    },
    function(jqXHR, textStatus, errorThrown){
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
         
         Common.alert('<spring:message code="sal.alert.title.saveFail" />' + DEFAULT_DELIMITER + '<spring:message code="sal.alert.msg.saveFail" />');
         
     });
          
}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.alert.msg.trBookMgmtTransferBulk" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body" style="min-height: auto"><!-- pop_body start -->

<form action="#" method="post" id="tranBForm" name="tranBForm">
    <input type="hidden" id="branchId" name="branchId" value ="${branchId}"/>

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.alert.msg.transferInformation" /></h2>
</aside><!-- title_line end -->

<table class="type1 mt10"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><span class="must">*</span><spring:message code="sal.alert.msg.transferFrom" /></th>
    <td>
        <select class="w100p" id="branchFrom" name="branchFrom">
        </select>
    </td>
</tr>
<tr>
    <th scope="row"><span class="must">*</span><spring:message code="sal.alert.msg.transferTo" /></th>
    <td>
        <select class="w100p" id="branchTo" name="branchTo">
        </select>
    </td>
</tr>
<tr>
    <th scope="row"><span class="must">*</span><spring:message code="sal.text.courier" /></th>
    <td>
        <select class="w100p" id="tBulkCourier" name="courier">
        </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.trBookSelection" /></h2>
</aside><!-- title_line end -->

<section class="transfer_wrap"><!-- transfer_wrap start -->
<div class="tran_list" style="height:300px"><!-- tran_list start -->
    <aside class="title_line"><!-- title_line start -->
    <h3><spring:message code="sal.title.text.bookHolding" /></h3>
    </aside><!-- title_line end -->
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="tranGridID" style="height:250px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
</div><!-- tran_list end -->

<ul class="btns">
    <li><a href="#" onclick="javascript:fn_holdDataMove();"><img src="${pageContext.request.contextPath}/resources/images/common/btn_right.gif" alt="right" /></a></li>
    <li class="sec"><a href="#" onclick="javascript:fn_tranDataMove();"><img src="${pageContext.request.contextPath}/resources/images/common/btn_left.gif" alt="left" /></a></li>
</ul>

<div class="tran_list" style="height:300px"><!-- tran_list start -->
    <aside class="title_line"><!-- title_line start -->
    <h3><spring:message code="sal.title.text.bookToTransfer" /></h3>
    </aside><!-- title_line end -->
    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="tranToGridID" style="height:250px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
</div><!-- tran_list end -->
</section><!-- transfer_wrap end -->

</form>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id="btnTranBulkSave" onclick="javascript:fn_tranBulkSave();"><spring:message code="sal.btn.save" /></a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
