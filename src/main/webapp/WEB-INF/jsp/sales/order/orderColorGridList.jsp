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

      //AUIGrid.setSelectionMode(myGridID, "singleRow");
        
        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
            $("#salesOrderId").val(event.item.ordId);
            Common.popupDiv("/sales/order/orderDetailPop.do", $("#searchForm").serializeJSON(), null, true, 'dtPop');
        });
        
        if($("#memType").val() == 1 || $("#memType").val() == 2){
        	if("${SESSION_INFO.memberLevel}" =="1"){

                $("#orgCode").val("${orgCode}");
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");
                
            }else if("${SESSION_INFO.memberLevel}" =="2"){

                $("#orgCode").val("${orgCode}");
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");
                
                $("#grpCode").val("${grpCode}");
                $("#grpCode").attr("class", "w100p readonly");
                $("#grpCode").attr("readonly", "readonly");
                            
            }else if("${SESSION_INFO.memberLevel}" =="3"){

                $("#orgCode").val("${orgCode}");
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");
                
                $("#grpCode").val("${grpCode}");
                $("#grpCode").attr("class", "w100p readonly");
                $("#grpCode").attr("readonly", "readonly");

                $("#deptCode").val("${deptCode}");
                $("#deptCode").attr("class", "w100p readonly");
                $("#deptCode").attr("readonly", "readonly");
                            
            }else if("${SESSION_INFO.memberLevel}" =="4"){
                
                $("#orgCode").val("${orgCode}");
                $("#orgCode").attr("class", "w100p readonly");
                $("#orgCode").attr("readonly", "readonly");
                 
                $("#grpCode").val("${grpCode}");
                $("#grpCode").attr("class", "w100p readonly");
                $("#grpCode").attr("readonly", "readonly");

                $("#deptCode").val("${deptCode}");
                $("#deptCode").attr("class", "w100p readonly");
                $("#deptCode").attr("readonly", "readonly");

                $("#memCode").val("${memCode}");
                $("#memCode").attr("class", "w100p readonly");
                $("#memCode").attr("readonly", "readonly");
            }
        }
        
        CommonCombo.make('cmbAppType', '/common/selectCodeList.do', {groupCode : 10} , '', {type: 'M'});
        doGetComboWh('/sales/order/colorGridProductList.do', '', '', 'cmbProduct', '', '');

    });
	
	function createAUIGrid() {
        // AUIGrid 칼럼 설정
        
        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var columnLayout = [ {
                dataField : "ordNo",
                headerText : "<spring:message code='sal.text.ordNo' />",
                width : 80,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "ordDt",
                headerText : "<spring:message code='sal.title.text.ordStus' />",
                width : 90,
                dataType : "date",
                formatString : "dd/mm/yyyy" ,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "stusCode",
                headerText : "<spring:message code='sal.title.text.ordStus' />",
                width : 100,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "appTypeCode",
                headerText : "<spring:message code='sal.title.text.appType' />",
                width : 80,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "custName",
                headerText : "<spring:message code='sal.text.custName' />",
                width : 120,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "stkCode",
                headerText : "<spring:message code='sal.title.text.product' />",
                width : 150,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "salesmanCode",
                headerText : "<spring:message code='sal.title.text.salesman' />",
                width : 100,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "installStus",
                headerText : "<spring:message code='sal.title.text.installStatus' />",
                width : 100,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "installFailResn",
                headerText : "<spring:message code='sal.title.text.failReason' />",
                width : 140,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "rsCnvrCnfmDt",
                headerText : "<spring:message code='sal.title.text.netMonth' />",
                width : 100,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "orgCode",
                headerText : "<spring:message code='sal.text.orgCode' />",
                width : 100,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "grpCode",
                headerText : "<spring:message code='sal.text.grpCode' />",
                width : 100,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "deptCode",
                headerText : "<spring:message code='sal.text.detpCode' />",
                width : 100,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "comDt",
                headerText : "<spring:message code='sal.title.text.comDate' />",
                width : 90,
                dataType : "date",
                formatString : "dd/mm/yyyy" ,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "payComDt",
                headerText : "<spring:message code='sal.title.text.payDate' />",
                width : 90,
                dataType : "date",
                formatString : "dd/mm/yyyy" ,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "ordId",
                visible : false
            }];

     // 그리드 속성 설정
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
        
        //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
        myGridID = AUIGrid.create("#list_grid_wrap", columnLayout, gridPros);
    }
    
    function fn_searchListAjax(){

        if( $("#netSalesMonth").val() ==""  &&  $("#createStDate").val() ==""  &&  $("#createEnDate").val() ==""  ){
        	if($("#ordNo").val() == "" && $("#custName").val() == "" && $("#custIc").val() == "" && $("#salesmanCode").val() == "" && $("#contactNum").val() == "" && $("#promoCode").val() == ""){
        		Common.alert("<spring:message code='sal.alert.msg.youMustKeyInatLeastOrdDateNetSales' />");
                return ;
        	}
         }
        
        //Search Condition max 31Days -- add by Lee seok hee
        if(($("#createStDate").val() != null && $("#createStDate").val() != '') || ($("#createEnDate").val() != null && $("#createEnDate").val() != '')){
        	
        	if($("#createStDate").val() == null || $("#createStDate").val() == ''){
        		Common.alert("<spring:message code='sal.alert.msg.pleaseKeyInStartDate' />");
        		return;
        	}
        	
        	if($("#createEnDate").val() == null || $("#createEnDate").val() == ''){
        		Common.alert("<spring:message code='sal.alert.msg.pleaseKeyInEndDate' />");
        		return;
        	}
        	
        	var startDate = $('#createStDate').val();
            var endDate = $('#createEnDate').val();
            
            if( fn_getDateGap(startDate , endDate) > 31){
                Common.alert('<spring:message code="sal.alert.msg.dateTermThirtyOneDay" />');
                return;
            }
        }
        
        
         
        Common.ajax("GET", "/sales/order/orderColorGridJsonList", $("#searchForm").serialize(), function(result) {
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
    }
    
    function fn_getDateGap(sdate, edate){
        
        var startArr, endArr;
        
        startArr = sdate.split('/');
        endArr = edate.split('/');
        
        var keyStartDate = new Date(startArr[2] , startArr[1] , startArr[0]);
        var keyEndDate = new Date(endArr[2] , endArr[1] , endArr[0]);
        
        var gap = (keyEndDate.getTime() - keyStartDate.getTime())/1000/60/60/24;
        
//        console.log("gap : " + gap);
        
        return gap;
    }
    

    //def Combo(select Box OptGrouping)
    function doGetComboWh(url, groupCd , selCode, obj , type, callbackFn){
      
      $.ajax({
          type : "GET",
          url : url,
          data : { groupCode : groupCd},
          dataType : "json",
          contentType : "application/json;charset=UTF-8",
          success : function(data) {
             var rData = data;
             Common.showLoader(); 
             fn_otpGrouping(rData, obj)
          },
          error: function(jqXHR, textStatus, errorThrown){
              alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
          },
          complete: function(){
              Common.removeLoader();
          }
      }); 
   } ;

   function fn_otpGrouping(data, obj){

       var targetObj = document.getElementById(obj);
       
       for(var i=targetObj.length-1; i>=0; i--) {
              targetObj.remove( i );
       }
       
       obj= '#'+obj;
       
       // grouping
       var count = 0;
       $.each(data, function(index, value){
           
           if(index == 0){
              $("<option />", {value: "", text: 'Choose One'}).appendTo(obj);
           }
           
           if(index > 0 && index != data.length){
               if(data[index].groupCd != data[index -1].groupCd){
                   $(obj).append('</optgroup>');
                   count = 0;
               }
           }
           
           if(data[index].codeId == null  && count == 0){
               $(obj).append('<optgroup label="">');
               count++;
           }
           if(data[index].codeId == 736 && count == 0){
               $(obj).append('<optgroup label="Air Purifier">');
               count++;
           }
           if(data[index].codeId == 110  && count == 0){
               $(obj).append('<optgroup label="Bidet">');
               count++;
           }
           if(data[index].codeId == 790 && count == 0){
               $(obj).append('<optgroup label="Juicer">');
               count++;
           }
           //
           if(data[index].codeId == 856 && count == 0){
               $(obj).append('<optgroup label="Point Of Entry ">');
               count++;
           }
           if(data[index].codeId == 538 && count == 0){
               $(obj).append('<optgroup label="Softener ">');
               count++;
           }
           if(data[index].codeId == 217 && count == 0){
               $(obj).append('<optgroup label="Water Purifier ">');
               count++;
           }

           $('<option />', {value : data[index].codeId, text: data[index].codeName}).appendTo(obj); // WH_LOC_ID
           
           
           if(index == data.length){
               $(obj).append('</optgroup>');
           }
       });
       //optgroup CSS
       $("optgroup").attr("class" , "optgroup_text");
       
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
                this.selectedIndex = -1;
            }
        });
    };
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code="sal.page.title.colorGrid" /></h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onClick="fn_searchListAjax()"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#searchForm').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="searchForm" name="searchForm" method="post">
    <input type="hidden" id="salesOrderId" name="salesOrderId">
    <input type="hidden" name="memType" id="memType" value="${memType }"/>
    <input type="hidden" name="initGrpCode" id="initGrpCode" value="${grpCode }"/>
    <input type="hidden" name="memCode" id="memCode" />
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
    <input type="text" title="" id="orgCode" name="orgCode" value="${orgCode }" placeholder="Organization Code" class="w100p" />
    </td>
    <th scope="row"><spring:message code="sal.title.text.groupCode" /></th>
    <td>
    <input type="text" title="" id="grpCode" name="grpCode" placeholder="Group Code" class="w100p" />
    </td>
    <th scope="row"><spring:message code="sal.title.text.deptCode" /></th>
    <td>
    <input type="text" title="" id="deptCode" name="deptCode" placeholder="Department Code" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sal.text.ordNo' /></th>
    <td>
    <input type="text" title="" id="ordNo" name="ordNo" placeholder="Order Number" class="w100p" />
    </td>
    <th scope="row"><spring:message code="sal.text.custName" /></th>
    <td>
    <input type="text" title="" id="custName" name="custName" placeholder="Customer Name" class="w100p" />
    </td>
    <th scope="row"><spring:message code="sal.title.text.nricCompNo" /></th>
    <td>
    <input type="text" title="" id="custIc" name="custIc" placeholder="NRIC/Company Number" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.appType" /></th>
    <td>
    <select class="multy_select w100p" id="cmbAppType" name="cmbAppType" multiple="multiple">
    </select>
    </td>
    <th scope="row"><spring:message code="sal.text.ordDate" /></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" id="createStDate" name="createStDate" placeholder="DD/MM/YYYY" class="j_date" readonly="readonly"/></p>
    <span><spring:message code="sal.text.to" /></span>
    <p><input type="text" title="Create end Date" id="createEnDate" name="createEnDate" placeholder="DD/MM/YYYY" class="j_date" readonly="readonly"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row"><spring:message code="sal.title.text.product" /></th>
    <td>
    <select class="w100p" id="cmbProduct" name="cmbProduct">
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.netSalesMonth" /></th>
    <td><input type="text" title="기준년월" id="netSalesMonth" name="netSalesMonth" placeholder="MM/YYYY" class="j_date2 w100p" /></td>
    <th scope="row"><spring:message code="sal.text.salManCode" /></th>
    <td>
    <input type="text" title="" id="salesmanCode" name="salesmanCode" placeholder="Salesman (Member Code)" class="w100p" />
    </td>
    <th scope="row"><spring:message code="sal.text.contactNumber" /></th>
    <td>
    <input type="text" title="" id="contactNum" name="contactNum" placeholder="Contact Number" class="w100p" />
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
        <option value="5"><spring:message code="sal.combo.text.installFailed" /></option>
        <option value="6"><spring:message code="sal.combo.text.installActive" /></option>
    </select>
    </td>
    <th scope="row"><spring:message code="sal.text.promotionCode" /></th>
    <td>
    <input type="text" title="" id="promoCode" name="promoCode" placeholder="Promotion Code" class="w100p" />
    </td>       
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row" colspan="6" ><span class="must"> <spring:message code="sal.alert.msg.youMustKeyInatLeastOrdDateNetSales" /></span>  </th>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start --
<p class="show_btn"><a href="#"><img src="../images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a href="#">menu1</a></p></li>
        <li><p class="link_btn"><a href="#">menu2</a></p></li>
        <li><p class="link_btn"><a href="#">menu3</a></p></li>
        <li><p class="link_btn"><a href="#">menu4</a></p></li>
        <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn"><a href="#">menu6</a></p></li>
        <li><p class="link_btn"><a href="#">menu7</a></p></li>
        <li><p class="link_btn"><a href="#">menu8</a></p></li>
    </ul>
    <ul class="btns">
        <li><p class="link_btn type2"><a href="#">menu1</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu3</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu4</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu6</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu7</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu8</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="../images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside> link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<ul class="left_btns">
    <li><span class="green_text"><spring:message code="sal.combo.text.netSales" /></span></li>
    <li><span class="pink_text"><spring:message code="sal.combo.text.cancel" /></span></li>
    <li><span class="yellow_text"><spring:message code="sal.text.completeWithUnit" /></span></li>
    <li><span class="black_text"><spring:message code="sal.combo.text.active" /></span></li>
</ul>

<section class="search_result"><!-- search_result start -->
<!-- 
<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
    <li><p class="btn_grid"><a href="#">NEW</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>
 -->
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="list_grid_wrap" style="width: 100%; height: 480px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->