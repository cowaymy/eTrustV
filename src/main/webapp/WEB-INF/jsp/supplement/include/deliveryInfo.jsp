<script type="text/javascript">
    var deliveryInfoGridID;

    $(document).ready(function() {
        createDelDetailGrid();
    });

    function createDelDetailGrid() {
        var columnLayout = [ {
            dataField : "delDt",
            headerText : "<spring:message code='log.head.deliverydate'/>",
            width : '20%',
            editable : false
        }, {
            dataField : "delStus",
            headerText : "<spring:message code='supplement.text.delStat'/>",
            width : '30%',
            editable : false
        }, {
            dataField : "delLoc",
            headerText : "<spring:message code='supplement.text.delLoc'/>",
            width : '20%',
            editable : false
        }, {
            dataField : "rmk",
            headerText : "<spring:message code='sal.title.remark'/>",
            width : '30%',
            editable : false,
        } ];

        var delRcdGridPros = {
            usePaging : true,
            pageRowCount : 10,
            fixedColumnCount : 1,
            showStateColumn : true,
            displayTreeOpen : false,
            headerHeight : 30,
            useGroupingPanel : false,
            skipReadonlyColumns : true,
            wrapSelectionMove : true,
            showRowNumColumn : true
        };

        deliveryInfoGridID = GridCommon.createAUIGrid("delivery_rec_grid_wrap", columnLayout, "", delRcdGridPros);
    }

    var supRefId = ${orderInfo.supRefId};
    var param = {supRefId : supRefId };
    Common.ajax("GET", "/supplement/getDelRcdLst", param, function(result) {
      AUIGrid.setGridData(deliveryInfoGridID, result);
    })
</script>

<article class="tap_area">
  <aside class="title_line">
    <h3><spring:message code="sal.title.text.deliveryAddress" /></h3>
  </aside>
  <table class="type1">
  <caption>table</caption>
  <colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:110px" />
    <col style="width:*" />
  </colgroup>
  <tbody>
    <tr>
      <th scope="row">Address Line 1</th>
      <td colspan="5"><span>${orderInfo.addressLine1}</span></td>
    </tr>
    <tr>
      <th scope="row">Address Line 2</th>
      <td colspan="5"><span>${orderInfo.addressLine2}</span></td>
    </tr>
    <tr>
      <th scope="row"><spring:message code="service.title.Area" /></th>
      <td><span>${orderInfo.area}</span></td>
      <th scope="row"><spring:message code="sal.text.city" /></th>
      <td><span>${orderInfo.city}</span></td>
      <th scope="row"><spring:message code="sys.title.postcode" /></th>
      <td><span>${orderInfo.postcode}</span></td>
    </tr>
    <tr>
      <th scope="row"><spring:message code="service.title.State" /></th>
      <td><span>${orderInfo.state}</span></td>
      <th scope="row"><spring:message code="sys.country"/></th>
      <td><span>${orderInfo.country}</span></td>
      <th </th>
      <td>
      </td>
    </tr>
  </tbody>
  </table>

  <aside class="title_line">
    <h3><spring:message code="supplement.text.delRcd" /></h3>
  </aside>
  <article class="tap_area">
    <article class="grid_wrap">
      <div id="delivery_rec_grid_wrap" style="width: 100%; height: 350px; margin: 0 auto;"></div>
    </article>
  </article>
</article>