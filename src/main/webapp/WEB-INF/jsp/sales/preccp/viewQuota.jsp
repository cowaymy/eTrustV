<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style>
	.height-style{
	    height:25px
	}
</style>

<div class="popup_wrap" id="popup_wrap2">
    <header class="pop_header">
        <h1 id="detailsHeader"></h1>
        <ul class="right_opt">
          <li><p class="btn_blue2"><a id="btnCloseView">CLOSE</a></p></li>
        </ul>
    </header>

    <section class="pop_body">
        <table class="type1">
            <colgroup>
                <col style="width:150px" />
                <col style="width:*" />
                <col style="width:150px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
                <tr>
                        <th scope="row">Total Quota</th>
                        <td><input type="text"  class="w100p" id="viewTotal" disabled></td>

                        <th scope="row">Update By</th>
                        <td><input type="text"  class="w100p" id="viewUpdator" disabled></td>
                </tr>
            </tbody>
        </table>

        <article class="grid_wrap">
                <div id="viewQuotaGrid" style="width:100%; height:400px; margin:0 auto;"></div>
        </article>
 </section>
</div>

<script>

    let request = ${request};

    $("#viewTotal").val(request[0].total);
    $("#viewUpdator").val(request[0].updator);

    document.querySelector("#detailsHeader").innerHTML = `Pre-CCP Quota - View ( Batch No : ` + request[0].batchId + ` )`;

    const viewQuotaGrid =  GridCommon.createAUIGrid('viewQuotaGrid',[
          {
              dataField : 'batchId', headerText : 'Batch No', editable : false, visible: false
          },
          {
              dataField : 'managerCode', headerText : 'Manager Code',  editable : false
          },
          {
              dataField : 'type', headerText : 'Type',  editable : false
          },
//           {
//               dataField : 'year', headerText : 'Year',  editable : false
//           },
//           {
//               dataField : 'month', headerText : 'Month',  editable : false
//           },
          {
              dataField : 'quota', headerText : 'Quota', width: '20%', editable : false
          }
    ],'',
    {
          usePaging: true,
          pageRowCount: 20,
          showRowNumColumn: true,
          wordWrap: true,
          showStateColumn: false,
          showRowCheckColumn : false,
          rowStyleFunction: (i, item) => { return "height-style"}
    });

   AUIGrid.setGridData(viewQuotaGrid, request);

</script>