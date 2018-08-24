<%-- 
    Document   : createlesson
    Created on : 30-ene-2017, 14:59:17
    Author     : nmohamed
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
    <%@ include file="infouser.jsp" %>
    <%@ include file="menu.jsp" %>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.form/4.2.2/jquery.form.min.js" integrity="sha384-FzT3vTVGXqf7wRfy8k4BiyzvbNfeYjK+frTVqZeNDFl8woCbF0CYG6g2fMEFFo/i" crossorigin="anonymous"></script>

    <head>
        <title><spring:message code='etiq.report'/></title>
        <script>


            $(document).ready(function () {
                $("#termIdInput").val(termId_view);
                $("#yearIdInput").val(yearId_view);
                
                // $('#loadingmessage').hide();
                $('#generateReport').attr('disabled', true);

                $("#generateReport").click(function () {
                    $('#destino option').prop('selected', true);
                    //  $('#loadingmessage').show()
                });

                $('.pasar').click(function () {
                    var exist = false;
                    $('#destino option').each(function () {
                        if ($('#origen option:selected').val() === $(this).val())
                            exist = true;
                    });

                    if (!exist)
                        !$('#origen option:selected').clone().appendTo('#destino');

                    var numAlum = $('#destino option').length;
                    if (numAlum > 0) {
                        $('#generateReport').attr('disabled', false);
                    } else {
                        $('#generateReport').attr('disabled', true);
                    }

                    $('#destino option').first().prop('selected', true);
                    return;
                });


                $('.quitar').click(function () {
                    !$('#destino option:selected').remove();
                    $('#destino option').first().prop('selected', true);

                    var alumnosSelected = $('#destino option').length;
                    if (alumnosSelected === 0) {
                        $('#generateReport').attr('disabled', true);
                    }
                    return;
                });
                $('.pasartodos').click(function () {
                    $('#origen option').each(function () {

                        var valueInsert = $(this).val();
                        var exist = false;
                        $('#destino option').each(function () {
                            if (valueInsert === $(this).val())
                                exist = true;
                        });

                        if (!exist)
                            $(this).clone().appendTo('#destino');
                    });

                    var numAlum = $('#destino option').length;
                    if (numAlum > 0) {
                        $('#generateReport').attr('disabled', false);
                    } else {
                        $('#generateReport').attr('disabled', true);
                    }

                    $('#destino option').first().prop('selected', true);
                });

                $('.quitartodos').click(function () {
                    $('#destino option').each(function () {
                        $(this).remove();
                    });
                    $('#generateReport').attr('disabled', true);
                });
                var selectlevel = "<spring:message code="etiq.selectlevel"/>";
                $("#levelStudent option[value='']").text(selectlevel);

            });

            function showResponse(responseText, statusText, xhr, $form) {
                // for normal html responses, the first argument to the success callback 
                // is the XMLHttpRequest object's responseText property 

                // if the ajaxForm method was passed an Options Object with the dataType 
                // property set to 'xml' then the first argument to the success callback 
                // is the XMLHttpRequest object's responseXML property 

                // if the ajaxForm method was passed an Options Object with the dataType 
                // property set to 'json' then the first argument to the success callback 
                // is the json data object returned by the server 

                //alert('jj'); 

            }
            var ajax;

            function funcionCallBackLevelStudent()
            {
                if (ajax.readyState === 4) {
                    if (ajax.status === 200) {
                        document.getElementById("origen").innerHTML = ajax.responseText;
                    }
                }
            }

            function ocultarLoading()
            {
                $('#loadingmessage').hide();
            }


            function comboSelectionLevelStudent()
            {
                if (window.XMLHttpRequest) //mozilla
                {
                    ajax = new XMLHttpRequest(); //No Internet explorer
                } else
                {
                    ajax = new ActiveXObject("Microsoft.XMLHTTP");
                }

                ajax.onreadystatechange = funcionCallBackLevelStudent;
                var seleccion = document.getElementById("levelStudent").value;
                var alumnos = document.getElementById("destino").innerHTML;
                ajax.open("POST", "studentlistLevel.htm?seleccion=" + seleccion, true);
                ajax.send("");
            }


            function comboSelectionLevel()
            {
                if (window.XMLHttpRequest) //mozilla
                {
                    ajax = new XMLHttpRequest(); //No Internet explorer
                } else
                {
                    ajax = new ActiveXObject("Microsoft.XMLHTTP");
                }

                $('#createOnClick').attr('disabled', true);
                $('#objective').val("");
                $('#subject').val("");

                ajax.onreadystatechange = funcionCallBackSubject;
                var seleccion1 = document.getElementById("level").value;
                ajax.open("POST", "subjectlistLevel.htm?seleccion1=" + seleccion1, true);
                $('#objective').val("");
                $('#subject').val("");
                ajax.send("");

            }

            function refresh() {
                $("#termIdInput").val($('#termSelect option:selected').val());
                $("#yearIdInput").val($('#yearSelect option:selected').val());
            }
        </script>
        <style>
            textarea 
            {
                resize: none;
            }
            .popover{
                width: 500px;
            }
            .unStyle
            {
                text-align: right;
                background-color: transparent !important;
                outline: none !important;
                box-shadow: none;
                border: none;
            }
            .desactivada
            {
                color: grey;
                text-decoration: line-through;
            }
            .btn span.glyphicon {    			
                opacity: 0;				
            }
            .btn.active span.glyphicon {				
                opacity: 1;				
            }
            /*STILOS CHECKBOX*/

            .checkbox {
                padding-left: 20px; }
            .checkbox label {
                display: inline-block;
                vertical-align: middle;
                position: relative;
                padding-left: 5px; }

            .checkbox label::before {
                content: "";
                display: inline-block;
                position: absolute;
                width: 17px;
                height: 17px;
                left: 0;
                margin-left: -20px;
                border: 1px solid #cccccc;
                border-radius: 3px;
                background-color: #fff;
                -webkit-transition: border 0.15s ease-in-out, color 0.15s ease-in-out;
                -o-transition: border 0.15s ease-in-out, color 0.15s ease-in-out;
                transition: border 0.15s ease-in-out, color 0.15s ease-in-out; }
            .checkbox label::after {
                display: inline-block;
                position: absolute;
                width: 16px;
                height: 16px;
                left: 0;
                top: 0;
                margin-left: -20px;
                padding-left: 3px;
                padding-top: 1px;
                font-size: 11px;
                color: #555555; }
            .checkbox input[type="checkbox"],
            .checkbox input[type="radio"] {
                opacity: 0;
                z-index: 1;
                cursor: pointer;
            }
            .checkbox input[type="checkbox"]:focus + label::before,
            .checkbox input[type="radio"]:focus + label::before {
                outline: thin dotted;
                outline: 5px auto -webkit-focus-ring-color;
                outline-offset: -2px; }
            .checkbox input[type="checkbox"]:checked + label::after,
            .checkbox input[type="radio"]:checked + label::after {
                font-family: "fontprincipal";
                content: '✔';}
            .checkbox input[type="checkbox"]:indeterminate + label::after,
            .checkbox input[type="radio"]:indeterminate + label::after {
                display: block;
                content: "";
                width: 10px;
                height: 3px;
                background-color: #555555;
                border-radius: 2px;
                margin-left: -16.5px;
                margin-top: 7px;
            }
            .checkbox input[type="checkbox"]:disabled,
            .checkbox input[type="radio"]:disabled {
                cursor: not-allowed;
            }
            .checkbox input[type="checkbox"]:disabled + label,
            .checkbox input[type="radio"]:disabled + label {
                opacity: 0.65; }
            .checkbox input[type="checkbox"]:disabled + label::before,
            .checkbox input[type="radio"]:disabled + label::before {
                background-color: #eeeeee;
                cursor: not-allowed; }
            .checkbox.checkbox-circle label::before {
                border-radius: 50%; }
            .checkbox.checkbox-inline {
                margin-top: 0; }


            .checkbox-success input[type="checkbox"]:checked + label::before,
            .checkbox-success input[type="radio"]:checked + label::before {
                background-color: #99CC66;
                border-color: #99CC66; }
            .checkbox-success input[type="checkbox"]:checked + label::after,
            .checkbox-success input[type="radio"]:checked + label::after {
                color: #fff;}



            .checkbox-success input[type="checkbox"]:indeterminate + label::before,
            .checkbox-success input[type="radio"]:indeterminate + label::before {
                background-color: #99CC66;
                border-color: #99CC66;
            }

            .checkbox-success input[type="checkbox"]:indeterminate + label::after,
            .checkbox-success input[type="radio"]:indeterminate + label::after {
                background-color: #fff;
            }


            input[type="checkbox"].styled:checked + label:after,
            input[type="radio"].styled:checked + label:after {
                font-family: 'fontprincipal';
                content: '✔'; }
            input[type="checkbox"] .styled:checked + label::before,
            input[type="radio"] .styled:checked + label::before {
                color: #fff; }
            input[type="checkbox"] .styled:checked + label::after,
            input[type="radio"] .styled:checked + label::after {
                color: #fff; }

            #generateReport{
                font-size: medium;
                width: 30%;

                margin-bottom: 10px;
            }
            .etiqReport{
                margin-top: 20px;
                padding-top: 5px !important;
                border-top: solid 1px lightgray;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1 class="text-center"><spring:message code='etiq.generateReport'/></h1>

            <c:url var="post_url"  value="/html" />
            <form:form id="formStudents" method ="post" action="${post_url}"  >
                <input id="termIdInput" name="termId" type="hidden" value="">
                <input id="yearIdInput" name="yearId" type="hidden" value="">
                <fieldset>
                    <legend id="showStudents">
                        <spring:message code='etiq.selectLearners'/>
                        <span class="col-xs-12 text-right glyphicon glyphicon-triangle-bottom"></span>
                    </legend>
                    <div class="form-group collapse in" id="contenedorStudents">
                        <div class="col-xs-12 sinpadding">
                            <div class="col-xs-3 sinpadding">
                                <label><spring:message code='etiq.filter'/></label>     
                            </div>
                        </div>
                        <div class="col-xs-12 sinpadding">
                            <div class="col-xs-12 sinpadding" style="margin-bottom:  10px;">
                                <select class="form-control" name="levelStudent" id="levelStudent" style="width: 33.4%;" onchange="comboSelectionLevelStudent()">
                                    <c:forEach var="levels" items="${gradelevels}">
                                        <option value="${levels.id[0]}" >${levels.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-xs-4 sinpadding">
                                <select class="form-control" size="20" multiple name="origen[]" id="origen" style="width: 100% !important;">
                                    <!--<select class="form-control" size="20" name="origen[]" id="origen" style="width: 100% !important;">-->
                                    <c:forEach var="alumnos" items="${listaAlumnos}">
                                        <option value="${alumnos.id_students}" >${alumnos.nombre_students}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="  col-xs-4">
                                <div class="col-xs-12 text-center btnStudents" style="padding-bottom: 10px; padding-top: 50px;">
                                    <input id='btnPasar' type="button" class="btn btn-success btn-block pasar" value="<spring:message code="etiq.txtadd"/> »">
                                </div>
                                <div class="col-xs-12 text-center btnStudents">
                                    <input type="button" class="btn btn-danger btn-block quitar" value="« <spring:message code="etiq.txtremove"/>">
                                </div>
                                <div class="col-xs-12 text-center btnStudents">
                                    <input id='btnPasarTodos' type="button" class="btn btn-success btn-block pasartodos" value="<spring:message code="etiq.txtaddAll"/> »">
                                </div>
                                <div class="col-xs-12 text-center btnStudents">
                                    <input type="button" class="btn btn-danger btn-block quitartodos" value="« <spring:message code="etiq.txtremoveAll"/>">
                                </div>
                            </div>

                            <div class=" col-xs-4 sinpadding">
                                <select class="form-control submit" size="20" multiple name="destino[]" id="destino" style="width: 100% !important;"> 

                                </select>
                            </div>
                        </div>
                    </div>
                </fieldset>
                <div class="col-xs-12 sinpadding etiqReport">
                    <div class="col-xs-3 sinpadding">
                        <label><spring:message code='etiq.report'/></label>     
                    </div>
                </div>
                <div class="col-xs-12 sinpadding">
                    <div class="col-xs-3 sinpadding">
                        <select class="form-control" name="typeReport" id="typeReport" style="width: 100% !important;" onchange="comboSelectionLevelStudent()">              
                            <option value="" disabled="true"  disabled="true"><spring:message code='etiq.selectType'/></option>
                            <option value="progress_prePrimary" >Progress Pre-Primary</option>
                            <option value="progress_Yr1_4" >Progress Yr1_4</option>
                            <option value="academic_Gr7" >Academic Report Gr7</option>   
                            <option value="academic_Gr7_JP" >Academic Report JP</option>  
                        </select>
                    </div>
                </div>

                <div class="hide col-xs-12 text-center">
                    <input type="submit" class="btn btn-success" id="createOnClick" value="<spring:message code="etiq.txtcreate"/>">
                </div>

                <div class="col-xs-12 form-check sinpadding">
                    <div class="col-xs-12 sinpadding">
                        <input type="checkbox" class="form-check-input" name="checkArchive" id="checkArchive">
                        <label class="form-check-label" for="checkArchive"><spring:message code='etiq.store'/></label>
                    </div>
                </div>

                <div class="col-xs-12 text-center">
                    <input type="submit" class="btn btn-info" id="generateReport" value="<spring:message code='etiq.generate'/>">
                </div>
            </form:form>
        </div>
        <div class="divLoadStudent" id="loadingmessage">
            <div class="text-center"> 
                <img class="imgLoading" src='../recursos/img/large_loading2.gif'/>
            </div>
        </div>
        <%--        <div class="col-xs-6">
                        <div class="form-group">
                            <label class="control-label"></label>
                                <div class='input-group' style="margin-top:19px;">
                                    <form:form id="formCreate" action="createsetting.htm?select=start">
                                       <button type="submit" id="crearLessons" value="Crear" class="btn btn-success">Create Settings</button>
                                    </form:form>
                                </div>
                        </div>
                </div>--%>
        <div class="modal fade" id="lessonIdeaCreated" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    </div>
                    <div class="modal-body text-center">
                        <H1><%= request.getParameter("message")%></H1>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal fade" id="lessonCreated" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <!--        <h4 class="modal-title" id="myModalLabel">Modal title</h4>-->
                    </div>
                    <div class="modal-body text-center">
                        <H1><%= request.getParameter("message")%></H1>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
