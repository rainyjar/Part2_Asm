// Dynamic Appointment Booking JavaScript
document.addEventListener('DOMContentLoaded', function() {
    initializeAppointmentBooking();
});

function initializeAppointmentBooking() {
    const treatmentSelect = document.getElementById('treatment');
    const dateInput = document.getElementById('appointment_date');
    const submitBtn = document.getElementById('submit-appointment');
    const finalConfirmBtn = document.getElementById('final-confirm');
    const form = document.getElementById('appointment-form');
    
    // Set minimum date to today
    const today = new Date().toISOString().split('T')[0];
    if (dateInput) {
        dateInput.setAttribute('min', today);
    }
    
    let selectedDoctor = null;
    let selectedTimeSlot = null;
    
    // Step 1: Treatment selection
    if (treatmentSelect) {
        treatmentSelect.addEventListener('change', function() {
            if (this.value) {
                showSection('date-section');
                updateStepIndicator(2);
            }
        });
    }
    
    // Step 2: Date selection
    if (dateInput) {
        dateInput.addEventListener('change', function() {
            if (this.value) {
                loadAvailableDoctors();
                showSection('doctor-section');
                updateStepIndicator(3);
            }
        });
    }
    
    // Submit appointment button
    if (submitBtn) {
        submitBtn.addEventListener('click', function() {
            if (validateForm()) {
                showConfirmationModal();
            }
        });
    }
    
    // Final confirmation
    if (finalConfirmBtn) {
        finalConfirmBtn.addEventListener('click', function() {
            if (form) {
                form.submit();
            }
        });
    }
    
    // Function to show section
    function showSection(sectionId) {
        const section = document.getElementById(sectionId);
        if (section) {
            section.classList.remove('hidden');
        }
    }
    
    // Function to update step indicator
    function updateStepIndicator(activeStep) {
        for (let i = 1; i <= 4; i++) {
            const step = document.getElementById('step' + i);
            if (step && i <= activeStep) {
                step.classList.add('active');
            }
        }
    }
    
    // Function to load available doctors (called from JSP)
    window.loadAvailableDoctors = function() {
        const doctorsContainer = document.getElementById('doctor-cards-container');
        if (doctorsContainer) {
            doctorsContainer.innerHTML = '<div class="text-center"><i class="fa fa-spinner fa-spin"></i> Loading available doctors...</div>';
            
            setTimeout(() => {
                doctorsContainer.innerHTML = '';
            }, 500);
        }
    };
    
    // Function to create simplified doctor card
    window.createDoctorCard = function(doctorId, doctorName, specialization) {
        const doctorsContainer = document.getElementById('doctor-cards-container');
        if (!doctorsContainer) return;
        
        const doctorCard = document.createElement('div');
        doctorCard.className = 'doctor-card';
        doctorCard.setAttribute('data-doctor-id', doctorId);
        
        // Generate sample time slots
        const timeSlots = ['09:00', '09:30', '10:00', '10:30', '11:00', '11:30', 
                          '14:00', '14:30', '15:00', '15:30', '16:00', '16:30'];
        
        // Randomly make some slots unavailable for demo
        const availableSlots = timeSlots.filter(() => Math.random() > 0.3);
        
        let timeSlotsHtml = '';
        timeSlots.forEach(slot => {
            const isAvailable = availableSlots.includes(slot);
            timeSlotsHtml += `<a class="time-slot ${isAvailable ? 'available' : 'unavailable'}" 
                              data-time="${slot}" ${!isAvailable ? 'style="pointer-events: none;"' : ''}>${slot}</a>`;
        });
        
        // Create simplified doctor card HTML
        doctorCard.innerHTML = `
            <div class="doctor-info-simple">
                <h5 class="doctor-name">${doctorName}</h5>
                <div class="doctor-specialization">${specialization || 'General Practice'}</div>
            </div>
            <div class="time-slots">
                ${timeSlotsHtml}
            </div>
        `;
        
        doctorsContainer.appendChild(doctorCard);
        
        // Add click handlers for time slots
        const slots = doctorCard.querySelectorAll('.time-slot.available');
        slots.forEach(slot => {
            slot.addEventListener('click', function() {
                handleTimeSlotSelection(doctorCard, doctorId, doctorName, this);
            });
        });
    };
    
    // Function to handle time slot selection
    function handleTimeSlotSelection(doctorCard, doctorId, doctorName, timeSlotElement) {
        // Clear previous selections
        document.querySelectorAll('.doctor-card').forEach(card => card.classList.remove('selected'));
        document.querySelectorAll('.time-slot').forEach(slot => slot.classList.remove('selected'));
        
        // Select this doctor and time
        doctorCard.classList.add('selected');
        timeSlotElement.classList.add('selected');
        
        selectedDoctor = {id: doctorId, name: doctorName};
        selectedTimeSlot = timeSlotElement.getAttribute('data-time');
        
        // Update hidden form fields
        const doctorIdField = document.getElementById('selected_doctor_id');
        const timeSlotField = document.getElementById('selected_time_slot');
        
        if (doctorIdField) doctorIdField.value = doctorId;
        if (timeSlotField) timeSlotField.value = selectedTimeSlot;
        
        // Show message section
        showSection('message-section');
        updateStepIndicator(4);
    }
    
    // Function to validate form
    function validateForm() {
        if (!treatmentSelect || !treatmentSelect.value) {
            showAlert('Please select a treatment', 'warning');
            return false;
        }
        if (!dateInput || !dateInput.value) {
            showAlert('Please select a date', 'warning');
            return false;
        }
        if (!selectedDoctor) {
            showAlert('Please select a doctor and time slot', 'warning');
            return false;
        }
        return true;
    }
    
    // Function to show confirmation modal
    function showConfirmationModal() {
        const treatmentText = treatmentSelect.options[treatmentSelect.selectedIndex].text;
        const customerMessageField = document.getElementById('customer_message');
        const customerMessage = customerMessageField ? customerMessageField.value || 'No specific concerns mentioned' : 'No message provided';
        
        // Update modal content
        updateModalContent('confirm-treatment', treatmentText);
        updateModalContent('confirm-doctor', selectedDoctor.name);
        updateModalContent('confirm-date', formatDate(dateInput.value));
        updateModalContent('confirm-time', selectedTimeSlot);
        updateModalContent('confirm-message', customerMessage);
        
        // Show modal
        const modal = document.getElementById('confirmationModal');
        if (modal) {
            if (typeof $ !== 'undefined' && $.fn.modal) {
                $('#confirmationModal').modal('show');
            } else {
                modal.style.display = 'block';
                modal.classList.add('show');
                document.body.classList.add('modal-open');
            }
        }
    }
    
    // Helper functions
    function updateModalContent(elementId, content) {
        const element = document.getElementById(elementId);
        if (element) {
            element.textContent = content;
        }
    }
    
    function formatDate(dateString) {
        if (!dateString) return '';
        const date = new Date(dateString);
        return date.toLocaleDateString('en-US', { 
            weekday: 'long', 
            year: 'numeric', 
            month: 'long', 
            day: 'numeric' 
        });
    }
    
    function showAlert(message, type) {
        type = type || 'info';
        const alertDiv = document.createElement('div');
        alertDiv.className = 'alert alert-' + type + ' alert-dismissible fade show';
        alertDiv.style.position = 'fixed';
        alertDiv.style.top = '20px';
        alertDiv.style.right = '20px';
        alertDiv.style.zIndex = '9999';
        alertDiv.style.maxWidth = '400px';
        
        const iconClass = type === 'warning' ? 'exclamation-triangle' : 'info-circle';
        alertDiv.innerHTML = '<i class="fa fa-' + iconClass + '"></i> ' + message + 
            '<button type="button" class="close" data-dismiss="alert"><span>&times;</span></button>';
        
        document.body.appendChild(alertDiv);
        
        setTimeout(function() {
            if (alertDiv && alertDiv.parentNode) {
                alertDiv.parentNode.removeChild(alertDiv);
            }
        }, 5000);
        
        const closeBtn = alertDiv.querySelector('.close');
        if (closeBtn) {
            closeBtn.addEventListener('click', function() {
                if (alertDiv && alertDiv.parentNode) {
                    alertDiv.parentNode.removeChild(alertDiv);
                }
            });
        }
    }
    
    // Modal close handlers
    const modal = document.getElementById('confirmationModal');
    if (modal) {
        const closeButtons = modal.querySelectorAll('[data-dismiss="modal"]');
        closeButtons.forEach(function(btn) {
            btn.addEventListener('click', function() {
                modal.style.display = 'none';
                modal.classList.remove('show');
                document.body.classList.remove('modal-open');
            });
        });
        
        modal.addEventListener('click', function(e) {
            if (e.target === modal) {
                modal.style.display = 'none';
                modal.classList.remove('show');
                document.body.classList.remove('modal-open');
            }
        });
    }
    
    // Auto-select treatment if pre-selected (called from JSP)
    window.handlePreSelectedTreatment = function() {
        setTimeout(function() {
            showSection('date-section');
            updateStepIndicator(2);
        }, 500);
    };
}
