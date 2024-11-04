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

	var excelListGridID;

	var arrSrvTypeCode = [
                          {"codeId": "SS"  ,"codeName": "Self Service"},
                          {"codeId": "HS" ,"codeName": "Heart Service"}
                        ];

	$(document).ready(function() {
		 doDefCombo(arrSrvTypeCode, '', 'cmbSrvType', 'S', '');
        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();
        createExcelAUIGrid();

      //AUIGrid.setSelectionMode(myGridID, "singleRow");

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
            $("#salesOrderId").val(event.item.ordId);
            Common.popupDiv("/sales/order/orderDetailPop.do", $("#searchForm").serializeJSON(), null, true, 'dtPop');
        });

        $("#orgCode").val($("#orgCode").val().trim());

        $("#memLvl").val("${SESSION_INFO.memberLevel}");

         if($("#memType").val() == 1 || $("#memType").val() == 2 || $("#memType").val() == 7){
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

                if($("#memType").val() == "7"){ //HTM
                   $("#memtype option[Value='"+$("#memType").val()+"']").attr("selected", true);
                   $("#memtype").attr("class", "w100p readonly");
                   $('#memtype').attr('disabled','disabled').addClass("disabled");
                }

            }else if("${SESSION_INFO.memberLevel}" =="4"){

                $("#orgCode").val("${orgCode}".trim());
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

                if($("#memType").val() == "7"){  // HT
	                $("#salesmanCode").val('${SESSION_INFO.userName}');
	                $("#salesmanCode").attr("class", "w100p readonly");
	                $("#salesmanCode").attr("readonly", "readonly");

	                $("#memtype option[Value='"+$("#memType").val()+"']").attr("selected", true);
	                $("#memtype").attr("class", "w100p readonly");
	                $('#memtype').attr('disabled','disabled').addClass("disabled");
                }
            }
        }

        //CommonCombo.make('cmbAppType', '/common/selectCodeList.do', {groupCode : 10} , '', {type: 'M'});
        doGetCombo('/common/selectCodeList.do', '10', '','cmbAppType', 'M' , 'f_multiCombo');
        doGetComboOrder('/sales/order/colorGridProductList.do', '', '', '', 'cmbProduct', 'M', 'f_multiCombo'); //Common Code
        //doGetComboWh('/sales/order/colorGridProductList.do', '', '', 'cmbProduct', '', '');
        doGetCombo('/common/selectCodeList.do', '8', '','cmbCustomerType', 'M' , 'f_multiCombo');            // Customer Type Combo Box
        doGetCombo('/common/selectCodeList.do', '95', '','cmbCorpTypeId', 'M' , 'f_multiCombo');     // Company Type Combo Box
        //CommonCombo.make('cmbCustomerType', '/common/selectCodeList.do', {groupCode : 8} , '', {type: 'M'});
        //CommonCombo.make('cmbCorpTypeId', '/common/selectCodeList.do', {groupCode : 95} , '', {type: 'M'});
        doGetCombo('/sales/promotion/selectProductCategoryList.do', '', '', 'cmbProductCtgry', 'M','f_multiCombo'); //Category
        doGetCombo('/organization/getStateList.do','' , ''   , 'cmbState' , 'M', 'f_multiCombo');//Added by keyi 20211105


        //excel download - added by Adib
        $('#excelDown').click(function() {
            var excelProps = {
                fileName     : "color_grid",
               exceptColumnFields : AUIGrid.getHiddenColumnDataFields(excelListGridID)
            };
            AUIGrid.exportToXlsx(excelListGridID, excelProps);
        });
    });


	// 조회조건 combo box
    function f_multiCombo(){
        $(function() {

        	$('#cmbAppType').change(function() {
        		$(this).find('[value="5764"]').remove(); //2021/09/29 KAHKIT
            }).multipleSelect({
                selectAll: true, // 전체선택
                width: '80%'
            });


            $('#cmbCustomerType').change(function() {

            }).multipleSelect({
                selectAll: true, // 전체선택
                width: '80%'
            });
            $('#cmbCorpTypeId').change(function() {

            }).multipleSelect({
                selectAll: true, // 전체선택
                width: '80%'
            });

            $('#cmbSalesType').change(function() {

            }).multipleSelect({
                selectAll: true, // 전체선택
                width: '80%'
            });

            $('#cmbCondition').change(function() {

            }).multipleSelect({
                selectAll: true, // 전체선택
                width: '80%'
            });

            $('#cmbProduct').change(function() {

            }).multipleSelect({
                selectAll: true, // 전체선택
                width: '80%'
            });

            $('#cmbProductCtgry').change(function() {

            }).multipleSelect({
                selectAll: true, // 전체선택
                width: '80%'
            });

             $('#cmbState').change(function() {

            }).multipleSelect({
                selectAll: true, // 전체선택
                width: '80%'
            });
        });
    }

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
                dataField : "chsStus",
                headerText : "<spring:message code='sal.text.chsStus' />",
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
                dataField : "ccpStus",
                headerText : "CCP Status",
                width : 100,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "ccpRemark",
                headerText : "CCP Remark",
                width : 200,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "neoProStatus",
                headerText : "Neo Pro",
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
                dataField : "keyInMonth",
                headerText : "Key In Month",
                width : 100,
                editable : false,
                style: 'left_style'
            },{
                //dataField : "rsCnvrCnfmDt",
                dataField : "netMonth",
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
                width : 80,
                dataType : "date",
                formatString : "dd/mm/yyyy" ,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "payComDt",
                headerText : "<spring:message code='sal.title.text.payDate' />",
                width : 80,
                dataType : "date",
                formatString : "dd/mm/yyyy" ,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "ordId",
                visible : false
            },{
                dataField : "state",
                headerText : "State",
                width : 80,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "isExtradePr",
                headerText : "Product Return",
                width : 120,
                editable : false,
                style: 'left_style'
            },{
            	dataField : "serviceType",
                headerText : "<spring:message code='sales.srvType'/>",
                width : 100,
                editable : false,
                style: 'left_style'
            }]; //added by keyi 20211105

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

	  function createExcelAUIGrid() {

		  // added by Adib 19/10/2022
		   var excelColumnLayout = [ {
               dataField : "ordNo",
               headerText : "Order No",
               width : 80,
               editable : false
               }, {
               dataField : "ordDt",
               headerText : "Order Date",
               dataType : "date",
               formatString : "dd/mm/yyyy" ,
               width : 90,
               editable : false
               }, {
               dataField : "stusCode",
               headerText : "Order Status",
               width : 100,
               editable : false
               }, {
               dataField : "appTypeCode",
               headerText : "App Type",
               width : 80,
               editable : false
               }, {
               dataField : "custName",
               headerText : "Customer Name",
               width : 120,
               editable : false
               }, {
               dataField : "chsStus",
               headerText : "CHS Status",
               width : 120,
               editable : false,
               }, {
               dataField : "stkCode",
               headerText : "Product",
               width : 150,
               editable : false
               }, {
               dataField : "salesmanCode",
               headerText : "Salesman",
               width : 100,
               editable : false
               }, {
               dataField : "ccpStus",
               headerText : "CCP Status",
               width : 80,
               editable : false
               }, {
               dataField : "ccpRemark",
               headerText : "CCP Remark",
               width : 150,
               editable : false
               }, {
               dataField : "neoProStatus",
               headerText : "Neo Pro",
               width : 100,
               editable : false
               }, {
               dataField : "installStus",
               headerText : "Install Status",
               width : 100,
               editable : false
               }, {
               dataField : "installFailResn",
               headerText : "Fail Reason",
               width : 140,
               editable : false
               }, {
               dataField : "keyInMonth",
               headerText : "Key In Month",
               width : 100,
               editable : false
               },{
               dataField : "netMonth",
               headerText : "Net Month",
               width : 100,
               editable : false
               }, {
               dataField : "orgCode",
               headerText : "Org Code",
               width : 100,
               editable : false
               }, {
               dataField : "grpCode",
               headerText : "Grp Code",
               width : 100,
               editable : false
               }, {
               dataField : "deptCode",
               headerText : "Dept Code",
               width : 100,
               editable : false
               }, {
               dataField : "comDt",
               headerText : "Com Date",
               dataType : "date",
               formatString : "dd/mm/yyyy" ,
               width : 80,
               editable : false
               }, {
               dataField : "payComDt",
               headerText : "Pay Date",
               dataType : "date",
               formatString : "dd/mm/yyyy" ,
               width : 80,
               editable : false
               }, {
               dataField : "state",
               headerText : "State",
               width : 80,
               editable : false,
               }, {
                   dataField : "isExtradePr",
                   headerText : "Product Return",
                   width : 100,
                   editable : false,
                   style: 'left_style'
               }, {
                   dataField : "cancellationRequestNo",
                   headerText : "OCR No",
                   width : 100,
                   editable : false,
                   style: 'left_style'
               }, {
                   dataField : "cancellationStatusName",
                   headerText : "OCR Status",
                   width : 100,
                   editable : false,
                   style: 'left_style'
               },{
                   dataField : "serviceType",
                   headerText : "<spring:message code='sales.srvType'/>",
                   width : 90,
                   editable : false,
                   style: 'left_style'
               }];


	        //그리드 속성 설정
	        var excelGridPros = {
	             enterKeyColumnBase : true,
	             useContextMenu : true,
	             enableFilter : true,
	             showStateColumn : true,
	             displayTreeOpen : true,
	             noDataMessage : "<spring:message code='sys.info.grid.noDataMessage' />",
	             groupingMessage : "<spring:message code='sys.info.grid.groupingMessage' />",
	             exportURL : "/common/exportGrid.do"
	         };

	        excelListGridID = GridCommon.createAUIGrid("excel_list_grid_wrap", excelColumnLayout, "", excelGridPros);
	    }

    function fn_searchListAjax(){

    	/*
        if( $("#netSalesMonth").val() ==""  &&  $("#createStDate").val() ==""  &&  $("#createEnDate").val() ==""  ){
        	if($("#ordNo").val() == "" && $("#custName").val() == "" && $("#custIc").val() == "" && $("#salesmanCode").val() == "" && $("#contactNum").val() == "" && $("#promoCode").val() == ""){
        		Common.alert("<spring:message code='sal.alert.msg.youMustKeyInatLeastOrdDateNetSales' />");
                return ;
        	}
         }
        */

        //  lev 1  Order Date    Order Date
        //  lev 2   netSalesMonth
       console.log("searchColorGrid");
        var isValid = true;
        if(FormUtil.isEmpty($("#ordNo").val())         &&
           FormUtil.isEmpty($("#contactNum").val()) &&
           FormUtil.isEmpty($("#salesmanCode").val()) &&
           FormUtil.isEmpty($("#custIc").val()) ){

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
	                  //Common.alert('<spring:message code="sal.alert.msg.dateTermThirtyOneDay" />');
	                  Common.alert("Start date can not be more than 365 days before the end date.");
	                  return;
	              }
	        }

	        if ($("#keyInMonth").val() == ""){
	        	 if( ($("#createStDate").val()  ==""  ||    $("#createEnDate").val()  =="" ) &&   $("#netSalesMonth").val() ==""  ){
                     isValid = false;
                 }
	        }else{
	        	var keyInMonth = $("#keyInMonth").val();
	        	var keyInMonthArr = keyInMonth.split('/');
	        	$("#keyinMon").val(keyInMonthArr[0]);
	        	$("#keyinYear").val(keyInMonthArr[1]);

	        	isValid = true;
	        }
        }

/*
       if( $("#createStDate").val()  !=""  &&   $("#createEnDate").val()  !=""  ){
            var startDate = $('#createStDate').val();
            var endDate = $('#createEnDate').val();
            if( fn_getDateGap(startDate , endDate) > 31){
                Common.alert('<spring:message code="sal.alert.msg.dateTermThirtyOneDay" />');
                return;
            }
        }
*/

/*
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
*/
         if(isValid == true){
        	var param =  $("#searchForm").serialize();
            var htMemberType = $('#memtype').find('option:selected').val();
        	if('${SESSION_INFO.memberLevel}' =="3" || '${SESSION_INFO.memberLevel}' =="4"){
        		 if(htMemberType == "7"){ // HTM & HT
           			    param += "&memtype="+htMemberType;
        		 }
        	}

	       	Common.ajax("GET", "/sales/order/orderColorGridJsonList", param, function(result) {
	            AUIGrid.setGridData(myGridID, result);
	            AUIGrid.setGridData(excelListGridID, result);

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
               Common.alert("<spring:message code='sal.alert.msg.youMustKeyInatLeastOrdDateNetSales' />");
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

        // console.log("gap : " + gap);
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

           if(data[index].codeId == 1653  && count == 0){
               $(obj).append('<optgroup label="Frame">');
               count++;
           }

           if(data[index].codeId == 790 && count == 0){
               $(obj).append('<optgroup label="Juicer">');
               count++;
           }

           if(data[index].codeId == 1646 && count == 0){
               $(obj).append('<optgroup label="Mattress">');
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
            	if($("#memType").val() != "7"){ //check not HT level
            		 this.selectedIndex = 0;
            	}
            }
            
            $("#cmbAppType").multipleSelect("checkAll");
            $("#cmbCustomerType").multipleSelect("uncheckAll");
            $("#cmbCorpTypeId").multipleSelect("uncheckAll");
            $("#cmbCondition").multipleSelect("uncheckAll");
            $("#cmbProduct").multipleSelect("uncheckAll");
            $("#cmbSalesType").multipleSelect("uncheckAll");
        });
    };

    $(function(){
    	$('#btnTermNConditionsLetter').click(function() {
    		$("#dataForm").show();
            //Param Set
            var gridObj = AUIGrid.getSelectedItems(myGridID);

            if(gridObj == null || gridObj.length <= 0 ){
                Common.alert('* <spring:message code="sal.alert.msg.noOrdSel" />');
                return;
            }

            var orderID = gridObj[0].item.ordId;
            $("#_repSalesOrderId").val(orderID);

            var date = new Date().getDate();
            if(date.toString().length == 1){
                date = "0" + date;
            }
            $("#downFileName").val("CowayTermsNConditionLetter_"+date+(new Date().getMonth()+1)+new Date().getFullYear());

            fn_letter_report();
    	});

    	$('#btnAirCondComboPck').click(function(){
    		$("#dataForm1").show();
    		 var date = new Date().getDate();
             if(date.toString().length == 1){
                 date = "0" + date;
             }

            $("#downFileNameAirCond").val("ComboPromotionReport_" +date+(new Date().getMonth()+1)+new Date().getFullYear());
    		fn_report();
    	});

    });

    function fn_letter_report() {
        var option = {
            isProcedure : false
        };
        Common.report("dataForm", option);
    }

   function fn_report() {
        var option = {
            isProcedure : false
        };
        Common.report("dataForm1", option);
    }
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
<!-- report Form -->
<form id="dataForm">
    <input type="hidden" id="fileName" name="reportFileName" value="/sales/TermNConditionsLetter.rpt" /><!-- Report Name  --><!-- V2 Report  created by Webster Lee 10072020 -->
    <input type="hidden" id="viewType" name="viewType" value="PDF" /><!-- View Type  -->
    <input type="hidden" id="downFileName" name="reportDownFileName" value="" /> <!-- Download Name -->
    <!-- params -->
    <input type="hidden" id="_repSalesOrderId" name="@salesOrderId" />
</form>

<form id="dataForm1">
    <input type="hidden" id="fileName" name="reportFileName" value="/sales/ColorGridAirConditionerBulkPromotion.rpt"/>
    <input type="hidden" id="viewType" name="viewType" value="EXCEL"/>
    <input type="hidden" id="downFileNameAirCond" name="reportDownFileName" value="" />
</form>

<section class="search_table"><!-- search_table start -->
<form id="searchForm" name="searchForm" method="post">
    <input type="hidden" id="salesOrderId" name="salesOrderId">
    <input type="hidden" name="memType" id="memType" value="${memType }"/>
    <input type="hidden" name="initGrpCode" id="initGrpCode" value="${grpCode }"/>
    <input type="hidden" name="memCode" id="memCode" />
    <input type="hidden" name="keyinMon" id="keyinMon" />
    <input type="hidden" name="keyinYear" id="keyinYear" />
    <input type="hidden" name="memLvl" id="memLvl"/>
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
    <p><input type="text" title="Create start Date" id="createStDate" name="createStDate" placeholder="DD/MM/YYYY" class="j_date" /></p>
    <span><spring:message code="sal.text.to" /></span>
    <p><input type="text" title="Create end Date" id="createEnDate" name="createEnDate" placeholder="DD/MM/YYYY" class="j_date" /></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row"><spring:message code="sal.title.text.product" /></th>
    <td>
    <select class="w100p" id="cmbProduct" name="cmbProduct" multiple="multiple">
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.netSalesMonth" /></th>
    <td><input type="text" title="기준년월" id="netSalesMonth" name="netSalesMonth" placeholder="MM/YYYY" class="j_date2 w100p" /></td>
    <th scope="row"><spring:message code="sal.text.salManCode" /></th>
    <td>
    <input type="text" title="" id="salesmanCode" name="salesmanCode" onkeyup="this.value = this.value.toUpperCase();" placeholder="Salesman (Member Code)" class="w100p" />
    </td>
    <th scope="row"><spring:message code="sal.text.contactNumber" /></th>
    <td>
    <input type="text" title="" id="contactNum" name="contactNum" placeholder="Contact Number" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.condition" /></th>
    <td>
    <select class="w100p" id="cmbCondition" name="cmbCondition" multiple="multiple">
        <!-- <option value="">Choose One</option> -->
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
    <th scope="row"><spring:message code="sal.text.memtype" /></th>
    <td>
    <select class="w100p" id="memtype" name="memtype">
        <option value="">Choose One</option>
        <option value="2"><spring:message code="sal.text.cowayLady" /></option>
        <option value="1"><spring:message code="sal.text.healthPlanner" /></option>
        <option value="4"><spring:message code="sal.text.staff" /></option>
        <option value="7"><spring:message code="sal.text.homecareTechinician" /></option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.custType" /></th>
    <td>
    <select class="multy_select w100p" id="cmbCustomerType" name="cmbCustomerType" multiple="multiple">
    </select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.companyType" /></th>
     <td>
       <select id="cmbCorpTypeId" name="cmbCorpTypeId" class="multy_select w100p" multiple="multiple">
        </select>
     </td>
     <th scope="row"><spring:message code="sales.promo.promoType" /></th>
     <td>
       <select class="w100p" id="cmbSalesType" name="cmbSalesType" class="multy_select w100p" multiple="multiple">
        <option value="0">New Sales</option>
        <option value="1">Extrade Sales</option>
        <option value="2">I-Care Sales</option>
        <option value="3">Combo Sales</option>
    </select>
     </td>
</tr>
<tr>
	<th scope="row"><spring:message code='sales.isEKeyin'/></th>
	<td>
	<input id="isEKeyin" name="isEKeyin" type="checkbox"/>
	</td>
    <th scope="row">is e-Commerce</th>
    <td>
    <input id="isECommerce" name="isECommerce" type="checkbox"/>
    </td>
    <th scope="row"><spring:message code="sal.title.text.productCategory" /></th>
    <td>
    <select class="w100p" id="cmbProductCtgry" name="cmbProductCtgry" multiple="multiple">
    </select>
    </td>
</tr>
<tr> <!-- Added by keyi 20211105 -->
    <th scope="row">State</th>
    <td>
    <select class="w100p" id="cmbState" name="cmbState">
     </select>
    </td>
    <th scope="row">Neo Pro Status</th>
    <td>
    <select class="w100p" id="neoPro" name="neoPro">
        <option value="0">Choose One</option>
        <option value="1">Yes</option>
        <option value="2">No</option>
    </td><!-- Added by Gaspar -->
      <th scope="row">Mattress Package</th>
    <td>
    <select class="w100p" id="matPack" name="matPack">
        <option value="">Choose One</option>
        <option value="set">Mattress set</option>
        <option value="mat">Mattress only</option>
    </td>
</tr>
<tr>
    <th scope="row">CCP Status</th>
    <td>
    <select class="w100p" id="ccpStus" name="ccpStus">
        <option value="">Choose One</option>
        <option value="appv">Approved</option>
        <option value="act">Active</option>
        <option value="rjct">Rejected</option>
    </td>
    <th scope="row">Key-in Month</th>
    <td><input type="text" title="기준년월" id="keyInMonth" name="keyInMonth" placeholder="MM/YYYY" class="j_date2 w100p" /></td>
    <th scope="row">With / Without PR</th>
    <td><select class="w100p" id="isExtradePr" name="isExtradePr">
        <option value="0">Choose One</option>
        <option value="1">Yes</option>
        <option value="2">No</option></td>
</tr>
<tr>
     <th scope="row"><spring:message code='sales.srvType'/></th>
     <td><select class="w100p" id="cmbSrvType" name="cmbSrvType"></td>
     <th scope="row"></th>
     <td></td>
     <th scope="row"></th>
     <td></td>
</tr>
<tr>
    <th scope="row" colspan="6" ><spaxn class="must"> <spring:message code="sal.alert.msg.youMustKeyInatLeastOrdDateNetSales" /></span>  </th>
</tr>
</tbody>
</table><!-- table end -->
</form>
<p></p>
<ul class="left_btns">
    <li><span class="green_text"><spring:message code="sal.combo.text.netSales" /></span></li>
    <li><span class="pink_text"><spring:message code="sal.combo.text.cancel" /></span></li>
    <li><span class="yellow_text"><spring:message code="sal.text.completeWithUnit" /></span></li>
    <li><span class="black_text"><spring:message code="sal.combo.text.active" /></span></li>
</ul>

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
     <ul class="btns">
     <c:if test="${PAGE_AUTH.funcUserDefine27== 'Y'}">
       <li><p class="link_btn"><a href="#" id="btnTermNConditionsLetter"><spring:message code='sales.btn.TermNConditionsLetter'/></a></p></li>
       </c:if>
       <c:if test="${PAGE_AUTH.funcUserDefine26== 'Y'}">
         <li><p class="link_btn"><a href="#" id="btnAirCondComboPck"><spring:message code='sales.btn.AirCondComboPmt'/></a></p></li>
       </c:if>
     </ul>

 <!--   <ul class="btns">
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
    </ul> -->
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside> <!-- link_btns_wrap end  -->

</section><!-- search_table end -->

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
<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" id="excelDown">GENERATE</a></p></li>
</ul>
</c:if>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="list_grid_wrap" style="width: 100%; height: 480px; margin: 0 auto;"></div>
        <div id="excel_list_grid_wrap" style="display: none;"></div>
</article><!-- grid_wrap end -->
</section><!-- search_result end -->

</section><!-- content end -->