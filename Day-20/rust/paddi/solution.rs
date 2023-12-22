fn main() {
    let input = include_str!("./data/inputs/day_20.txt");
    println!("Part A: \x1b[1m{}\x1b[0m", part_a(input).unwrap());
    println!("Part B: \x1b[1m{}\x1b[0m", part_b(input).unwrap());
}

use std::collections::VecDeque;
use std::ops::Not;
use std::{cell::RefCell, rc::Rc};

trait Module: std::fmt::Debug {
    fn process_pulse(&mut self, pulse: Pulse);
    fn send_pulses(&self) -> Vec<(Pulse, Rc<RefCell<dyn Module>>)>;
    fn get_state(&self) -> State;
    fn get_name(&self) -> String;
    fn add_child(&mut self, child: Rc<RefCell<dyn Module>>);
    fn add_parent(&mut self, parent: Rc<RefCell<dyn Module>>);
    fn get_children(&self) -> &Vec<Rc<RefCell<dyn Module>>>;
    fn get_module_type(&self) -> ModuleType;
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum ModuleType {
    Broadcast,
    Flipflop,
    Conjunction,
    Sink,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum Pulse {
    Low,
    High,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum State {
    On,
    Off,
}

impl Not for State {
    type Output = Self;
    fn not(self) -> Self::Output {
        if self == State::On {
            State::Off
        } else {
            State::On
        }
    }
}

impl From<State> for Pulse {
    fn from(value: State) -> Self {
        match value {
            State::On => Pulse::High,
            State::Off => Pulse::Low,
        }
    }
}

#[derive(Debug, Clone)]
struct FlipFlop {
    should_propagate: bool,
    name: String,
    state: State,
    child_modules: Vec<Rc<RefCell<dyn Module>>>,
}

#[derive(Debug, Clone)]
struct Conjunction {
    name: String,
    state: State,
    child_modules: Vec<Rc<RefCell<dyn Module>>>,
    parent_modules: Vec<Rc<RefCell<dyn Module>>>,
}

#[derive(Debug, Clone)]
struct Broadcast {
    child_modules: Vec<Rc<RefCell<dyn Module>>>,
}

#[derive(Debug, Clone)]
struct Sink {
    name: String,
}

impl Module for Broadcast {
    fn process_pulse(&mut self, _pulse: Pulse) {
        panic!("Cannot update the broadcast module")
    }

    fn send_pulses(&self) -> Vec<(Pulse, Rc<RefCell<dyn Module>>)> {
        let mut receivers = Vec::new();
        for child in self.child_modules.iter() {
            // println!("broadcast -OFF-> {}", child.borrow().get_name());
            receivers.push((State::Off.into(), child.clone()));
        }
        receivers
    }

    fn get_state(&self) -> State {
        State::Off
    }

    fn get_name(&self) -> String {
        String::from("broadcaster")
    }

    fn add_child(&mut self, child: Rc<RefCell<dyn Module>>) {
        self.child_modules.push(child);
    }

    fn add_parent(&mut self, _parent: Rc<RefCell<dyn Module>>) {}

    fn get_children(&self) -> &Vec<Rc<RefCell<dyn Module>>> {
        &self.child_modules
    }

    fn get_module_type(&self) -> ModuleType {
        ModuleType::Broadcast
    }
}

impl Module for Sink {
    fn get_name(&self) -> String {
        self.name.clone()
    }

    fn get_state(&self) -> State {
        panic!("Unable to get state of sink module {}", self.name)
    }

    fn add_child(&mut self, _child: Rc<RefCell<dyn Module>>) {
        panic!("Unable to add child to sink module {}", self.name)
    }

    fn add_parent(&mut self, _parent: Rc<RefCell<dyn Module>>) {
        panic!("Unable to add partent to child module {}", self.name)
    }

    fn send_pulses(&self) -> Vec<(Pulse, Rc<RefCell<dyn Module>>)> {
        Vec::new()
    }

    fn get_children(&self) -> &Vec<Rc<RefCell<dyn Module>>> {
        panic!("Unable to get children of sink module {}", self.name)
    }

    fn process_pulse(&mut self, _pulse: Pulse) {}

    fn get_module_type(&self) -> ModuleType {
        ModuleType::Sink
    }
}

impl Module for FlipFlop {
    fn process_pulse(&mut self, pulse: Pulse) {
        match pulse {
            Pulse::Low => {
                self.state = !self.state;
                self.should_propagate = true;
            }
            Pulse::High => self.should_propagate = false,
        }
    }

    fn send_pulses(&self) -> Vec<(Pulse, Rc<RefCell<dyn Module>>)> {
        let mut receivers = Vec::new();
        if self.should_propagate {
            for child in self.child_modules.iter() {
                // println!("{} -{:?}-> {}", self.name, self.state, child.borrow().get_name());
                receivers.push((self.state.into(), child.clone()));
            }
        }
        receivers
    }

    fn get_state(&self) -> State {
        self.state
    }

    fn get_name(&self) -> String {
        self.name.clone()
    }

    fn add_child(&mut self, child: Rc<RefCell<dyn Module>>) {
        self.child_modules.push(child);
    }

    fn add_parent(&mut self, _parent: Rc<RefCell<dyn Module>>) {}

    fn get_children(&self) -> &Vec<Rc<RefCell<dyn Module>>> {
        &self.child_modules
    }

    fn get_module_type(&self) -> ModuleType {
        ModuleType::Flipflop
    }
}

impl Module for Conjunction {
    fn process_pulse(&mut self, _pulse: Pulse) {
        if self
            .parent_modules
            .iter()
            .all(|parent| parent.borrow().get_state() == State::On)
        {
            self.state = State::Off
        } else {
            self.state = State::On
        }
    }

    fn send_pulses(&self) -> Vec<(Pulse, Rc<RefCell<dyn Module>>)> {
        let mut receivers = Vec::new();
        for child in self.child_modules.iter() {
            // println!("{} -{:?}-> {}", self.name, self.state, child.borrow().get_name());
            receivers.push((self.state.into(), child.clone()));
        }
        receivers
    }

    fn get_state(&self) -> State {
        self.state
    }

    fn get_name(&self) -> String {
        self.name.clone()
    }

    fn add_child(&mut self, child: Rc<RefCell<dyn Module>>) {
        self.child_modules.push(child);
    }

    fn add_parent(&mut self, parent: Rc<RefCell<dyn Module>>) {
        self.parent_modules.push(parent);
    }

    fn get_children(&self) -> &Vec<Rc<RefCell<dyn Module>>> {
        &self.child_modules
    }

    fn get_module_type(&self) -> ModuleType {
        ModuleType::Conjunction
    }
}

pub fn part_a(input: &str) -> Option<u64> {
    let lines = input.lines();
    let mut modules: Vec<Rc<RefCell<dyn Module>>> = Vec::new();

    for line in lines.clone() {
        let (description, _) = line.split_once(" -> ").unwrap();

        let module = match line.chars().next().unwrap() {
            '%' => Rc::new(RefCell::new(FlipFlop {
                should_propagate: true,
                name: description.strip_prefix('%').unwrap().to_string(),
                state: State::Off,
                child_modules: Vec::new(),
            })) as _,
            '&' => Rc::new(RefCell::new(Conjunction {
                name: description.strip_prefix('&').unwrap().to_string(),
                state: State::Off,
                child_modules: Vec::new(),
                parent_modules: Vec::new(),
            })) as _,
            _ => Rc::new(RefCell::new(Broadcast {
                child_modules: Vec::new(),
            })) as _,
        };

        modules.push(module);
    }

    for line in lines {
        let (description, children) = line.split_once(" -> ").unwrap();
        let name = description
            .strip_prefix('%')
            .or(description.strip_prefix('&'))
            .unwrap_or(description);

        let current_module = modules
            .iter()
            .find(|module| module.borrow().get_name() == *name)
            .unwrap()
            .clone();

        for child_name in children.split(", ") {
            if let Some(child) = modules
                .iter()
                .find(|module| module.borrow().get_name() == *child_name)
            {
                current_module.borrow_mut().add_child(child.clone());
                child.borrow_mut().add_parent(current_module.clone());
            } else {
                let sink = Rc::new(RefCell::new(Sink {
                    name: child_name.to_string(),
                }));

                current_module.borrow_mut().add_child(sink.clone());
                modules.push(sink);
            }
        }
    }

    let broadcaster = modules
        .iter()
        .find(|module| module.borrow().get_name() == *"broadcaster")
        .unwrap()
        .clone();
    let mut pulse_queue = VecDeque::new();

    let n = 1000;
    let mut high_pulses = 0;
    let mut low_pulses = n;
    for _ in 0..n {
        // println!("{i}th press");
        for pulse in broadcaster.borrow().send_pulses() {
            pulse_queue.push_back(pulse);
        }
        while let Some(next_pulse) = pulse_queue.pop_front() {
            if next_pulse.0 == Pulse::High {
                high_pulses += 1
            } else {
                low_pulses += 1
            };
            next_pulse.1.borrow_mut().process_pulse(next_pulse.0);
            for pulse in next_pulse.1.borrow().send_pulses() {
                pulse_queue.push_back(pulse);
            }
        }
    }

    // println!("High: {} Low: {}", high_pulses, low_pulses);
    Some(high_pulses * low_pulses)
}

pub fn part_b(_input: &str) -> Option<u64> {
    None
}
