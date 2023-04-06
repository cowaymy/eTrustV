<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

    <div class="popup_wrap size_big" id="editRemark">
        <header class="pop_header">
            <h1>Edit Remark</h1>
            <ul class="right_opt">
                <li><p class="btn_blue2"><a id="eclose">CLOSE</a></p></li>
            </ul>
        </header>
        <section class="search_result">
		       <article class="grid_wrap">
		           <div id="remarkGrid" style="width:100%; height:480px; margin:0 auto;"></div>
		       </article>
        </section>
    </div>


<script>
    const remarkGrid = GridCommon.createAUIGrid("remarkGrid", [
             {dataField: 'chsStus', headerText: 'CHS Status'},
             {dataField: 'chsRsn', headerText: 'CHS Reason'},
             {dataField: 'appvReq'
             , headerText: 'New Sales Approval Requirements'
             ,  renderer : {
                 type : "TemplateRenderer"
             },
             labelFunction : function (rowIndex, columnIndex, value, headerText,  item ) {
                 return value;
             }
             },
             {dataField: 'remarkId', headerText: 'Edit',
            	 renderer: {
                     type: "ButtonRenderer",
                     labelText: "Edit",
                     onclick : function(rowIndex, columnIndex, value, item) {
                    	 Common.popupDiv("/sales/ccp/preCcpEditRemarkDetails.do", {remarkId : value});
                     },
                 }
             },
      ], '', {
          usePaging: true,
          pageRowCount: 20,
          editable: false,
          headerHeight: 60,
          showRowNumColumn: true,
          wordWrap: true,
          showStateColumn: false
      })


       fetch("/sales/ccp/getPreCcpRemark.do")
       .then(r => r.json())
       .then(resp => {
                resp = resp.map(i => {
                    return {
                        ...i,
                        remarkId:  i.remarkId,
                        chsStus:  i.chsStus,
                        chsRsn:  i.chsRsn,
                        appvReq:  i.appvReq
                    }
                })
        AUIGrid.setGridData(remarkGrid, resp)
      })



</script>