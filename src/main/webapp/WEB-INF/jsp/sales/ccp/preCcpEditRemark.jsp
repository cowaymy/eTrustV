<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<!--     <div class="popup_wrap size_big" id="editRemark"> -->
<!--         <header class="pop_header"> -->
<!--             <h1>Edit Remark</h1> -->
<!--             <ul class="right_opt"> -->
<!--                 <li><p class="btn_blue2"><a id="eclose">CLOSE</a></p></li> -->
<!--             </ul> -->
<!--         </header> -->
<!--         <section class="search_result"> -->
<!-- 		       <article class="grid_wrap"> -->
<!-- 		           <div id="remarkGrid" style="width:100%; height:480px; margin:0 auto;"></div> -->
<!-- 		       </article> -->
<!--         </section> -->
<!--     </div> -->


<!-- <script> -->
//     const remarkGrid = GridCommon.createAUIGrid("remarkGrid", [
//              {dataField: 'chsStus', headerText: 'CHS Status'},
//              {dataField: 'chsRsn', headerText: 'CHS Reason'},
//              {dataField: 'appvReq'
//              , headerText: 'New Sales Approval Requirements'
//              ,  renderer : {
//                  type : "TemplateRenderer"
//              },
//              labelFunction : function (rowIndex, columnIndex, value, headerText,  item ) {
//                  return value;
//              }
//              },
//              {dataField: 'remarkId', headerText: 'Edit',
//             	 renderer: {
//                      type: "ButtonRenderer",
//                      labelText: "Edit",
//                      onclick : function(rowIndex, columnIndex, value, item) {
//                     	 Common.popupDiv("/sales/ccp/preCcpEditRemarkDetails.do", {remarkId : value});
//                      },
//                  }
//              },
//       ], '', {
//           usePaging: true,
//           pageRowCount: 20,
//           editable: false,
//           headerHeight: 60,
//           showRowNumColumn: true,
//           wordWrap: true,
//           showStateColumn: false
//       })


//        fetch("/sales/ccp/getPreCcpRemark.do")
//        .then(r => r.json())
//        .then(resp => {
//                 resp = resp.map(i => {
//                     return {
//                         ...i,
//                         remarkId:  i.remarkId,
//                         chsStus:  i.chsStus,
//                         chsRsn:  i.chsRsn,
//                         appvReq:  i.appvReq
//                     }
//                 })
//         AUIGrid.setGridData(remarkGrid, resp)
//       })



<!-- </script> -->

<style type="text/css">
.aui-grid-left-column {
        text-align: left;
}

.title{
    font-weight: bold;
    padding: 10px 0px;
}

#editRemark{
    height: 550px;
}
</style>

<script  type="text/javaScript" language="javascript">
	var ccpRemarkGridID;
	var existCustRemarkGridID;

	 $(document).ready(function(){
		 createAUIGrid();
		 createAUIGrid2();

		 fn_getCustCredibility();
	 });

	$(function(){
	    $("#vsave").click(function(){
	        var url = "/sales/ccp/editCCPRemark.do";
	        let updateList = AUIGrid.getEditedRowItems(ccpRemarkGridID);
	        let updateExistCustList = AUIGrid.getEditedRowItems(existCustRemarkGridID);
	        let data = {};
	        data.update = updateList;
	        data.updateExistCust = updateExistCustList;

	        if(data.update.length < 1 && data.updateExistCust.length < 1){
	            Common.alert("No Changes");
	            return;
	        }

	        Common.ajax("POST", url , data , function(result){
	            Common.alert("Configuration saved");
	            $("#eclose").click();
	        });
	    });
	});

	function createAUIGrid() {
        var columnLayout = [
            {   dataField: 'remarkId', headerText: 'Remark ID',visible: false, editable:false},
            {   dataField: 'custCredit', headerText: 'Customer Credibility',width: '15%', editable:false},
            {   dataField: 'ccpRem'
                , headerText: 'CCP Remark'
                , style : "aui-grid-left-column"
                , editRenderer : {
                	type : "InputEditRenderer",
                	// 에디팅 유효성 검사
                	validator : function(oldValue, newValue, item, dataField) {
                          var isValid = true;
                          var rtnMsg = "";

                          if(newValue.length > 200) {
                              isValid = false;
                              rtnMsg = "The maximum of characters is 200.";
                          }

                          // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                          return { "validate" : isValid, "message"  : rtnMsg };
                      }
                  }
             }
        ];

        var gridPros = {
                usePaging: true,
                editable: true,
                headerHeight: 40,
                showRowNumColumn: true,
                wordWrap: true,
                showStateColumn: true
        };

        ccpRemarkGridID = GridCommon.createAUIGrid("newCustRemarkGrid", columnLayout, "", gridPros);
    }

	function createAUIGrid2() {
        var columnLayout2 = [
            {   dataField: 'remarkId', headerText: 'Remark ID',visible: false, editable:false},
            {   dataField: 'chsStus', headerText: 'CHS Status',width: '15%', editable:false},
            {   dataField: 'ccpRem'
                , headerText: 'CCP Remark'
                , style : "aui-grid-left-column"
                , editRenderer : {
                	type : "InputEditRenderer",
                	// 에디팅 유효성 검사
                	validator : function(oldValue, newValue, item, dataField) {
                          var isValid = true;
                          var rtnMsg = "";

                          if(newValue.length > 200) {
                              isValid = false;
                              rtnMsg = "The maximum of characters is 200.";
                          }

                          // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
                          return { "validate" : isValid, "message"  : rtnMsg };
                      }
                  }
             }
        ];

        var gridPros2 = {
                usePaging: true,
                editable: true,
                headerHeight: 40,
                showRowNumColumn: true,
                wordWrap: true,
                showStateColumn: true
        };

        existCustRemarkGridID = GridCommon.createAUIGrid("existCustRemarkGrid", columnLayout2, "", gridPros2);
    }

	function fn_getCustCredibility(){
		 Common.ajax("GET", "/sales/ccp/getCustCredibility.do", "", function(result) {
	            AUIGrid.setGridData(ccpRemarkGridID, result);
	     });

		 Common.ajax("GET", "/sales/ccp/getExistCustChs.do", "", function(result) {
	            AUIGrid.setGridData(existCustRemarkGridID, result);
	     });
	}

</script>

<div class="popup_wrap size_big" id="editRemark">
    <header class="pop_header">
        <h1>Edit Remark</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a id="eclose">CLOSE</a></p></li>
        </ul>
    </header>
    <section class="pop_body search_result">
           <article class="grid_wrap">
               <div class="title">New Customer Credibility</div>
               <div id="newCustRemarkGrid" style="width:100%; height:300px; margin:0 auto;"></div>
           </article>

           <article class="grid_wrap">
               <div class="title">Existing Customer CHS Status</div>
               <div id="existCustRemarkGrid" style="width:100%; height:150px; margin:0 auto;"></div>
           </article>
           <ul class="center_btns">
               <li><p class="btn_blue2 big"><a id="vsave">SAVE</a></p></li>
           </ul>
    </section>
</div>