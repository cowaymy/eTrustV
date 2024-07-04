<script type="text/javaScript" language="javascript">

    //AUIGrid ���� �� ��ȯ ID
    var custInfoGridID;
    var oriNric = "${orderDetail.basicInfo.custNric}";

    $(document).ready(function(){
        //AUIGrid �׸��带 �����մϴ�.
        createAUIGrid();

        fn_selectOrderSameRentalGroupOrderList();

     // Masking pen (display last 4)
        if('${orderDetail.basicInfo.custType}' == "Individual") {
            var maskedNric = oriNric.substr(-4).padStart(oriNric.length, '*');
            $("#spanNric").html(maskedNric);
            // Appear NRIC on hover over field
            $("#spanNric").hover(function() {
                $("#spanNric").html(oriNric);
            }).mouseout(function() {
                $("#spanNric").html(maskedNric);
            });
            $("#imgHover").hover(function() {
                $("#spanNric").html(oriNric);
            }).mouseout(function() {
                $("#spanNric").html(maskedNric);
            });
        } else {
            $("#spanNric").html(oriNric);
        }
    });

    function createAUIGrid() {

        //AUIGrid Į�� ����
        var columnLayout = [
            { headerText : '<spring:message code="sal.text.ordNo" />',         dataField : "salesOrdNo", width   : 100   }
          , { headerText : '<spring:message code="sal.text.status" />',        dataField : "code",       width   : 100   }
          , { headerText : '<spring:message code="sal.title.text.appType" />', dataField : "code1",      width   : 100   }
          , { headerText : '<spring:message code="sal.text.ordDate" />',       dataField : "salesDt",    width   : 120   }
          , { headerText : '<spring:message code="sal.text.custName" />',      dataField : "name"                        }
          , { headerText : '<spring:message code="sal.text.nricCompanyNo" />', dataField : "nric",       width   : 150   }
          , { headerText : "salesOrdId",                                       dataField : "salesOrdId", visible : false }
          ];

        custInfoGridID = GridCommon.createAUIGrid("grid_custInfo_wrap", columnLayout, "", gridPros);
    }

    // ����Ʈ ��ȸ.
    function fn_selectOrderSameRentalGroupOrderList() {
        Common.ajax("GET", "/sales/order/selectSameRentalGrpOrderJsonList.do", {salesOrderId : '${orderDetail.basicInfo.ordId}'}, function(result) {
            AUIGrid.setGridData(custInfoGridID, result);
        });
    }

</script>

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.customerId" /></th>
    <td><span>${orderDetail.basicInfo.custId}</span></td>
    <th scope="row"><spring:message code="sal.text.custName" /></th>
    <td colspan="3"><span>${orderDetail.basicInfo.custName} ${orderDetail.basicInfo.memInfo}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.custType" /></th>
    <td><span>${orderDetail.basicInfo.custType}</span></td>
    <th scope="row"><spring:message code="sal.text.nricCompanyNo" /></th>
    <td><a href="#" class="search_btn" id="imgHover"><img style="height:70%" src="${pageContext.request.contextPath}/resources/images/common/nricEye2.png" /></a>
        <span id="spanNric"></span>
    </td>
    <th scope="row"><spring:message code="sal.text.jomPayRef1" /></th>
    <td><span>${orderDetail.basicInfo.jomPayRef}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.nationality" /></th>
    <td><span>${orderDetail.basicInfo.custNation}</span></td>
    <th scope="row"><spring:message code="sal.text.gender" /></th>
    <td><span>${orderDetail.basicInfo.custGender}</span></td>
    <th scope="row"><spring:message code="sal.text.race" /></th>
    <td><span>${orderDetail.basicInfo.custRace}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.vaNumber" /></th>
    <td><span>${orderDetail.basicInfo.custVaNo}</span></td>
    <th scope="row"><spring:message code="sal.text.passportExpire" /></th>
    <td><span>${orderDetail.basicInfo.custPassportExpr}</span></td>
    <th scope="row"><spring:message code="sal.text.visaExpire" /></th>
    <td><span>${orderDetail.basicInfo.custVisaExpr}</span></td>
</tr>
<tr>
    <th scope="row">Customer Status</th>
    <td><span>${orderDetail.basicInfo.custStatus}</span></td>
    <th scope="row"><spring:message code="sal.text.sstRegistrationNo" /></th>
    <td><span>${orderDetail.basicInfo.sstRgistNo}</span></td>
    <th scope="row"><spring:message code="sal.text.tin" /></th>
    <td><span>${orderDetail.basicInfo.custTin}</span></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.sameRentGrpOrd" /></h2>
</aside><!-- title_line end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_custInfo_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</article><!-- tap_area end -->