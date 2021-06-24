<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">

/* 커스텀 행 스타일 */
.my-yellow-style {
    background:#FFE400;
    font-weight:bold;
    color:#22741C;
}

.my-pink-style {
    background:#FFA7A7;
    font-weight:bold;
    color:#22741C;
}

.my-green-style {
    background:#86E57F;
    font-weight:bold;
    color:#22741C;
}
</style>
<script type="text/javaScript">
    //AUIGrid 생성 후 반환 ID
    var myGridID;

    $(document).ready(function() {

        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();

        $("#orgCode").val($("#orgCode").val().trim());

         if($("#memType").val() == 2){
            if("${SESSION_INFO.memberLevel}" =="0"){

                $("#memtype").val('${SESSION_INFO.userTypeId}');
                $("#memtype").attr("class", "w100p readonly");
                $('#memtype').attr('disabled','disabled').addClass("disabled");

            }else if("${SESSION_INFO.memberLevel}" =="1"){

                $("#orgCode").val("${orgCode}".trim());
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");

            }else if("${SESSION_INFO.memberLevel}" =="2"){

                $("#orgCode").val("${orgCode}".trim());
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");

                $("#grpCode").val("${grpCode}");
                $("#grpCode").attr("class", "w100p readonly");
                $("#grpCode").attr("readonly", "readonly");

            }else if("${SESSION_INFO.memberLevel}" =="3"){
                $("#orgCode").val("${orgCode}".trim());
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");

                $("#grpCode").val("${grpCode}");
                $("#grpCode").attr("class", "w100p readonly");
                $("#grpCode").attr("readonly", "readonly");

                $("#deptCode").val("${deptCode}");
                $("#deptCode").attr("class", "w100p readonly");
                $("#deptCode").attr("readonly", "readonly");

            }
        }

    });

    function createAUIGrid() {
        // AUIGrid 칼럼 설정

        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var columnLayout = [ {
                dataField : "mbrshNo",
                headerText : "<spring:message code='sal.title.mbrshNo' />",
                width : 120,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "mbrshType",
                headerText : "<spring:message code='sal.title.mbrshType' />",
                width : 120,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "salesOrdNo",
                headerText : "<spring:message code='sal.title.ordNo' />",
                width : 80,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "custName",
                headerText : "<spring:message code='sal.title.custName' />",
                width : 150,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "mbrshStartDt",
                headerText : "<spring:message code='sal.title.stDate' />",
                width : 100,
                dataType : "date",
                formatString : "dd/mm/yyyy" ,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "mbrshExprDt",
                headerText : "<spring:message code='sal.title.expireDate' />",
                width : 100,
                dataType : "date",
                formatString : "dd/mm/yyyy" ,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "mbrshStusCode",
                headerText : "<spring:message code='sal.title.status' />",
                width : 80,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "mbrshCrtDt",
                headerText : "<spring:message code='sal.title.crtDate' />",
                width : 100,
                dataType : "date",
                formatString : "dd/mm/yyyy" ,
                editable : false,
                style: 'left_style'
            }, {
            	dataField : "pacName",
            	headerText : "<spring:message code='sal.title.package' />",
            	width : 150,
            	editable : false,
            	style: 'left_style'
            }, {
                dataField : "salesmanCode",
                headerText : "<spring:message code='sal.title.text.salesman' />",
                width : 80,
                editable : false,
                style: 'left_style'
            }, {
            	dataField : "netMonth",
            	headerText : "<spring:message code='sal.title.text.netMonth' />",
            	width : 80,
            	editable : false,
            	style: 'left_style'
            }, {
            	dataField : "mbrshDur",
            	headerText : "<spring:message code='sal.title.durationMth' />",
            	width : 75,
            	editable : false,
            	style: 'left_style'
            }, {
                dataField : "orgCode",
                headerText : "<spring:message code='sal.text.orgCode' />",
                width : 90,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "grpCode",
                headerText : "<spring:message code='sal.text.grpCode' />",
                width : 90,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "deptCode",
                headerText : "<spring:message code='sal.text.detpCode' />",
                width : 90,
                editable : false,
                style: 'left_style'
            }];

        var gridPros = {

            // 페이징 사용
            usePaging : true,
            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 20,
            editable : true,
            fixedColumnCount : 1,
            showStateColumn : false,
            displayTreeOpen : true,
            selectionMode : "multipleCells",
            headerHeight : 30,
            // 그룹핑 패널 사용
            useGroupingPanel : false,
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : false,

            groupingMessage : "Here groupping"
        };

        myGridID = AUIGrid.create("#list_grid_wrap", columnLayout, gridPros);
    }

    function fn_searchListAjax(){

        var isValid = true;

        if(FormUtil.isEmpty($("#orderNo").val())   &&
           FormUtil.isEmpty($("#salesmanCode").val()) ){

            if (  $("#netSalesMonth").val() ==""   &&   $("#createStDate").val()  =="" ){
                isValid = false;
            }

            if (  ($("#createStDate").val()  ==""  &&   $("#createEnDate").val()  =="")     &&  $("#netSalesMonth").val() ==""   ){
                isValid = false;
            }

            if (   $("#netSalesMonth").val() ==""   ){
                 if( $("#createStDate").val()  ==""  ||    $("#createEnDate").val()  ==""  ){
                     isValid = false;
                 }
                  var startDate = $('#createStDate').val();
                  var endDate = $('#createEnDate').val();
                  if( fn_getDateGap(startDate , endDate) > 365){
                      Common.alert("Start date can not be more than 365 days before the end date.");
                      return;
                  }
            }
        }

        if(isValid == true){
            var param =  $("#searchForm").serialize();

            Common.ajax("GET", "/sales/membership/membershipColorGridJsonList", param, function(result) {
                AUIGrid.setGridData(myGridID, result);

                AUIGrid.setProp(myGridID, "rowStyleFunction", function(rowIndex, item) {
                    if(item.stusId == 4) {
                        if(item.isNet == 1){
                            return "my-green-style";
                        }else{
                            return "my-yellow-style";
                        }

                    }else if(item.stusId == 10){
                        return "my-pink-style";
                    }else{
                        return "";
                    }

                 });

                 // 변경된 rowStyleFunction 이 적용되도록 그리드 업데이트
                 AUIGrid.update(myGridID);
            });

        }else{
            Common.alert("<spring:message code='sal.alert.msg.youMustKeyInatLeastCrtDateNetSales' />");
            return ;
        }
    }

    function fn_getDateGap(sdate, edate){

        var startArr, endArr;

        startArr = sdate.split('/');
        endArr = edate.split('/');

        var keyStartDate = new Date(startArr[2] , startArr[1] , startArr[0]);
        var keyEndDate = new Date(endArr[2] , endArr[1] , endArr[0]);

        var gap = (keyEndDate.getTime() - keyStartDate.getTime())/1000/60/60/24;

        return gap;
    }

    $.fn.clearForm = function() {
        return this.each(function() {
            var type = this.type, tag = this.tagName.toLowerCase();
            if (tag === 'form'){
                return $(':input',this).clearForm();
            }
            if (type === 'text' || type === 'password'  || tag === 'textarea'){
                if($("#"+this.id).hasClass("readonly")){

                }else{
                    this.value = '';
                }
            }else if (type === 'checkbox' || type === 'radio'){
                this.checked = false;

            }else if (tag === 'select'){
                     this.selectedIndex = 0;
            }
        });
    };

</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Membership</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code="sal.page.title.colorGridMembership" /></h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onClick="fn_searchListAjax()"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#searchForm').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="searchForm" name="searchForm" method="post">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.orgCode" /></th>
    <td>
    <input type="text" title="" id="orgCode" name="orgCode" onkeyup="this.value = this.value.toUpperCase();" value="${orgCode}" placeholder="Organization Code" class="w100p" />
    </td>
    <th scope="row"><spring:message code="sal.title.text.groupCode" /></th>
    <td>
    <input type="text" title="" id="grpCode" name="grpCode" onkeyup="this.value = this.value.toUpperCase();" placeholder="Group Code" class="w100p" />
    </td>
    <th scope="row"><spring:message code="sal.title.text.deptCode" /></th>
    <td>
    <input type="text" title="" id="deptCode" name="deptCode" onkeyup="this.value = this.value.toUpperCase();" placeholder="Department Code" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.condition" /></th>
    <td>
    <select class="w100p" id="cmbCondition" name="cmbCondition">
        <option value="">Choose One</option>
        <option value="1"><spring:message code="sal.combo.text.active" /></option>
        <option value="2"><spring:message code="sal.combo.text.cancel" /></option>
        <option value="3"><spring:message code="sal.combo.text.netSales" /></option>
        <option value="4"><spring:message code="sal.combo.text.yellowSheet" /></option>
    </select>
    </td>
    <th scope="row">Membership Type</th>
    <td>
     <select class="w100p" id="membershipType" name="membershipType">
        <option value="">Choose One</option>
        <option value="RENTAL">Rental Membership</option>
        <option value="OUTRIGHT">Outright Membership</option>
    </select>
    </td>
    <th scope="row">Order Number</th>
    <td>
    <input type="text" title="" id="orderNo" name="orderNo" placeholder="Order Number" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Create Date</th> <!-- TODO [Yong] : create entry for spring message -->
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" id="createStDate" name="createStDate" placeholder="DD/MM/YYYY" class="j_date" readonly="readonly"/></p>
    <span><spring:message code="sal.text.to" /></span>
    <p><input type="text" title="Create end Date" id="createEnDate" name="createEnDate" placeholder="DD/MM/YYYY" class="j_date" readonly="readonly"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row"><spring:message code="sal.text.netSalesMonth" /></th>
    <td><input type="text" title="기준년월" id="netSalesMonth" name="netSalesMonth" placeholder="MM/YYYY" class="j_date2 w100p" /></td>
    <th scope="row"><spring:message code="sal.text.salManCode" /></th>
    <td>
    <input type="text" title="" id="salesmanCode" name="salesmanCode" onkeyup="this.value = this.value.toUpperCase();" placeholder="Salesman (Member Code)" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row" colspan="6" ><span class="must"> <spring:message code="sal.alert.msg.youMustKeyInatLeastCrtDateNetSales" /></span>  </th>
</tr>
</tbody>
</table><!-- table end -->
</form>
<p></p>
<ul class="left_btns">
    <li><span class="green_text"><spring:message code="sal.combo.text.netSales" /></span></li>
    <li><span class="pink_text"><spring:message code="sal.combo.text.cancel" /></span></li>
    <li><span class="yellow_text">Complete</span></li>
    <li><span class="black_text"><spring:message code="sal.combo.text.active" /></span></li>
</ul>

</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="list_grid_wrap" style="width: 100%; height: 480px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->