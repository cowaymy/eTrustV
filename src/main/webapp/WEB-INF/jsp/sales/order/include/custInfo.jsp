<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var custInfoGridID;
    
    $(document).ready(function(){
        //AUIGrid 그리드를 생성합니다.
        createAUIGrid();
        
        fn_selectOrderSameRentalGroupOrderList();
    });
    
    function createAUIGrid() {
        
        //AUIGrid 칼럼 설정
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
    
    // 리스트 조회.
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
    <td><span>${orderDetail.basicInfo.custNric}</span></td>
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