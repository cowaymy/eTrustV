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

#textAreaWrap, #textAreaWrap2{
    font-size: 12px;
    position: absolute;
    height: 100px;
    min-width: 100px;
    background: #fff;
    border: 1px solid #555;
    display: none;
    padding: 4px;
    text-align: right;
    z-index: 9999;
}

#textAreaWrap textarea, #textAreaWrap2 textarea {
    font-size: 12px;
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
               	, renderer : {
                       type : "TemplateRenderer",
                   },
                   labelFunction : function (rowIndex, columnIndex, value, headerText, item ) { // HTML 템플릿 작성
                       let v = value.replace(/\n/g, '<br/>');
                       return v;
                   },
                   editRenderer: {
                       type: "InputEditRenderer",
                       showEditorBtnOver: true
                   },
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
               	, renderer : {
                       type : "TemplateRenderer",
                   },
                   labelFunction : function (rowIndex, columnIndex, value, headerText, item ) { // HTML 템플릿 작성
                       let v = value.replace(/\n/g, '<br/>');
                       return v;
                   },
                   editRenderer: {
                       type: "InputEditRenderer",
                       showEditorBtnOver: true
                   },
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

	            AUIGrid.bind(ccpRemarkGridID, "cellEditBegin", function (event) {
	                if (event.which == "editorBtn")
	                    {createMyCustomEditRenderer(event, "newCust");}
	                }
	            );

	            $("#confirmBtn").click(function (event) {
	                let value = $("#ccpRemTextarea").val();
	                let selectedIndex = AUIGrid.getSelectedIndex(ccpRemarkGridID)[0];

	                AUIGrid.setCellValue(ccpRemarkGridID, selectedIndex, "ccpRem", value);

	                $("#textAreaWrap").hide();
	            });

	            $("#cancelBtn").click(function (event) {
	                $("#textAreaWrap").hide();
	            });
	     });

		 Common.ajax("GET", "/sales/ccp/getExistCustChs.do", "", function(result) {
	            AUIGrid.setGridData(existCustRemarkGridID, result);

	            AUIGrid.bind(existCustRemarkGridID, "cellEditBegin", function (event) {
	                if (event.which == "editorBtn")
	                    {createMyCustomEditRenderer    (event, "existCust");}
	                }
	            );

	            $("#confirmBtn2").click(function (event) {
	                let value = $("#ccpRemTextarea2").val();
	                let selectedIndex = AUIGrid.getSelectedIndex(existCustRemarkGridID)[0];

	                AUIGrid.setCellValue(existCustRemarkGridID, selectedIndex, "ccpRem", value);

	                $("#textAreaWrap2").hide();
	            });

	            $("#cancelBtn2").click(function (event) {
	                $("#textAreaWrap2").hide();
	            });
	     });
	}

	function createMyCustomEditRenderer(event, remType) {

        var dataField = event.dataField;
        var $obj;
        var $textArea;

        if (dataField == "ccpRem") {
        	  if(remType == "newCust"){
	            $obj = $("#textAreaWrap").css({
	                left: event.position.x,
	                top: event.position.y,
	                width: event.size.width - 100,
	                height: 120
	            }).show();
	            $textArea = $("#ccpRemTextarea").val(event.value);

	            setTimeout(function () {
	                $textArea.focus();
	                $textArea.select();
	            }, 16);
	        }else{
	        	 $obj = $("#textAreaWrap2").css({
	                    left: event.position.x,
	                    top: event.position.y,
	                    width: event.size.width - 100,
	                    height: 120
	                }).show();
	                $textArea = $("#ccpRemTextarea2").val(event.value);

	                setTimeout(function () {
	                    $textArea.focus();
	                    $textArea.select();
	                }, 16);
	        }

        }
    }

    function removeMyCustomEditRenderer(event, remType) {
    	if(remType == "newCust"){
    	    $("#textAreaWrap").hide();
    	}else{
    		$("#textAreaWrap2").hide();
    	}
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

		    <div id="textAreaWrap">
		          <textarea id="ccpRemTextarea" style="width:100%; height:90px;"></textarea>
		          <ul class="right_btns" style="margin-top:4px;">
		              <li><p class="btn_grid"><a id="confirmBtn">confirm</a></p></li>
		              <li><p class="btn_grid"><a id="cancelBtn">cancel</a></p></li>
		          </ul>
		    </div>

           <article class="grid_wrap">
               <div class="title">Existing Customer CHS Status</div>
               <div id="existCustRemarkGrid" style="width:100%; height:150px; margin:0 auto;"></div>
           </article>

           <div id="textAreaWrap2">
		          <textarea id="ccpRemTextarea2" style="width:100%; height:90px;"></textarea>
		          <ul class="right_btns" style="margin-top:4px;">
		              <li><p class="btn_grid"><a id="confirmBtn2">confirm</a></p></li>
		              <li><p class="btn_grid"><a id="cancelBtn2">cancel</a></p></li>
		          </ul>
		    </div>

           <ul class="center_btns">
               <li><p class="btn_blue2 big"><a id="vsave">SAVE</a></p></li>
           </ul>
    </section>



</div>